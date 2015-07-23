require 'net/http'

class WeChatController < ApplicationController
  protect_from_forgery with: :null_session

  WE_CHAT_APPID = 'wx6f7f654fa403d982'
  WE_CHAT_secret = '243470137e472878da8d9c77dece4d09'
  WE_CHAT_TOKEN = 'san'

  def auth_token
    if check_signature?(params["timestamp"], params["signature"], params["nonce"])
      return render text: params["echostr"]
    end
  end

  def msg_post
    # puts "params: #{params}"
    return unless check_signature?(params["timestamp"], params["signature"], params["nonce"])

    msg_type = params[:xml][:MsgType]
    if msg_type == 'text'
      msg_text
    elsif msg_type == 'event'
      msg_event
    elsif msg_type == 'image'
    elsif msg_type == 'location'
    else
    end
  end

  def msg_text
    openid = params[:xml][:FromUserName]
    customer = Customer.find_or_create(openid)
    customer.update_we_chat_info(get_we_chat_info)
    customer_point = customer.point
    @reply_content = "您的积分是：#{customer_point} 点"
    render partial: "we_chat/echo", layout: false, formats: :xml
  end

  def msg_event
    event = params[:xml][:Event]
    openid = params[:xml][:FromUserName]
    if event == 'subscribe'
      Customer.find_or_create(openid)
      @reply_content = "#{get_we_chat_info['nickname']}，感谢您关注英芮城生化科技"
      render partial: "we_chat/echo", layout: false, formats: :xml
    elsif event == 'unsubscribe'
      render nothing: true
    elsif event == 'CLICK'
      customer = Customer.find_or_create(openid)
      customer.update_we_chat_info(get_we_chat_info)
      customer_point = customer.point
      @reply_content = "您的积分是：#{customer_point} 点"
      render partial: "we_chat/echo", layout: false, formats: :xml
    else
    end
  end

  def get_we_chat_info
    uri = 'https://api.weixin.qq.com/cgi-bin/user/info'
    req_params = { access_token: get_access_token, openid: openid = params[:xml][:FromUserName], lang: 'zh_CN' }
    http_get(uri, req_params)
  end

  def get_access_token
    if Rails.cache.read("access_token").nil?
      uri = "https://api.weixin.qq.com/cgi-bin/token"
      req_params = { grant_type: "client_credential", appid: WE_CHAT_APPID, secret: WE_CHAT_secret }
      @access_token = http_get(uri, req_params)["access_token"]
      Rails.cache.write("access_token", @access_token, expires_in: 5.minutes)
      @access_token
    else
      @access_token = Rails.cache.read("access_token")
    end
  end

  def http_get(uri, req_params)
    uri = URI(uri)
    uri.query = URI.encode_www_form(req_params)
    res = Net::HTTP.get_response(uri)
    JSON.parse(res.body)
  end

  def addmenu
    post_url = "https://api.weixin.qq.com/cgi-bin/menu/create?access_token=#{get_access_token}"
    post_data = {
      button: [
        {
          name: '关于我们',
          sub_button: [
            {
              type: 'view',
              name: '公司简介',
              url: 'http://www.bio-enriching.com/list.php?catid=2'
            },
            {
              type: 'view',
              name: '新闻中心',
              url: 'http://www.bio-enriching.com/list.php?catid=36'
            },
            {
              type: 'view',
              name: '联系我们',
              url: 'http://www.bio-enriching.com/list.php?catid=50'
            }
          ]
        },
        {
          name: '产品中心',
          sub_button: [
            {
              type: 'view',
              name: '磁珠法试剂盒',
              url: 'http://www.bio-enriching.com/list.php?catid=40'
            },
            {
              type: 'view',
              name: '纳米磁珠材料',
              url: 'http://www.bio-enriching.com/list.php?catid=59'
            },
            {
              type: 'view',
              name: '仪器',
              url: 'http://www.bio-enriching.com/list.php?catid=53'
            },
            {
              type: 'view',
              name: '耗材',
              url: 'http://www.bio-enriching.com/list.php?catid=69'
            }]
        },
        {
          type: 'click',
          name: '我的积分',
          key: 'MY_POINT'
        }]
    }
    response = Typhoeus::Request.post(post_url, body: post_data.to_json)
    errcode = JSON.parse(response.body)["errcode"]
    if errcode == 0
      render text: '菜单创建成功'
    else
      render text: "菜单创建失败：#{response.body}"
    end
    # render nothing:true
  end

  private

    def check_signature?(timestamp, signature, nonce)
      array = [WE_CHAT_TOKEN, timestamp, nonce]
      return signature == Digest::SHA1.hexdigest(array.sort.join)
    end
end
