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
              url: 'http://mp.weixin.qq.com/s?__biz=MzIxOTAyMTk4Nw==&mid=208266197&idx=2&sn=f57ec9ca0867a61f1f069ea6d054519a#rd'
            },
            {
              type: 'view',
              name: '联系我们',
              url: 'http://mp.weixin.qq.com/s?__biz=MzIxOTAyMTk4Nw==&mid=208266197&idx=3&sn=8325b2bb37bdcd76b278f17aa0a13319#rd'
            }
          ]
        },
        {
          name: '产品中心',
          sub_button: [
            {
              type: 'media_id',
              name: '磁珠法试剂盒',
              media_id: 'stI_MkE6AU0WjzXaYJZMPozf_w3RQK8H-HuWCPWsQxY'
            },
            {
              type: 'view',
              name: '纳米磁珠材料',
              url: 'http://www.bio-enriching.com/list.php?catid=59'
            },
            {
              type: 'view',
              name: '耗材',
              url: 'http://www.bio-enriching.com/list.php?catid=69'
            }]
        },

        {
          name: '积分',
          sub_button: [
            {
              type: 'media_id',
              name: '积分介绍',
              media_id: 'stI_MkE6AU0WjzXaYJZMPi7w8h_oeyjg6K7Nh1ZayoI'
            },
            {
              type: 'view',
              name: '我的积分',
              url: 'http://mp.weixin.qq.com/s?__biz=MzIxOTAyMTk4Nw==&mid=208266522&idx=1&sn=ff042db23267f516e4226de8ab0662d8&scene=18#rd'
            }]
        }]
    }
    response = Typhoeus::Request.post(post_url, body: encoding_transform(post_data.to_json))
    errcode = JSON.parse(response.body)["errcode"]
    if errcode == 0
      render text: '菜单创建成功'
    else
      render text: "菜单创建失败：#{response.body}"
    end
    # render nothing:true
  end

  def fetch_material_list
    post_url = "https://api.weixin.qq.com/cgi-bin/material/batchget_material?access_token=#{get_access_token}"
    post_data = {
      type: "news",
      offset: 0,
      count: 20
    }
    response = Typhoeus::Request.post(post_url, body: post_data.to_json)
    errcode = JSON.parse(response.body)["errcode"]
    if errcode.nil?
      material_list = JSON.parse(response.body)
      render text: "素材列表获取成功"
    else
      render text: "素材列表获取失败：#{response.body}"
    end
  end

  def encoding_transform(str)
    str.gsub!(/\\u([0-9a-z]{4})/) {|s| [$1.to_i(16)].pack("U")}
  end

  private

    def check_signature?(timestamp, signature, nonce)
      array = [WE_CHAT_TOKEN, timestamp, nonce]
      return signature == Digest::SHA1.hexdigest(array.sort.join)
    end
end
