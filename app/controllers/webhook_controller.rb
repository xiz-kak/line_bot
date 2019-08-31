class WebhookController < ApplicationController

  def callback
    body = request.body.read
    events = client.parse_events_from(body)

    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          if (event.message['text'] == '連絡帳')
            message = {
              type: 'text',
              text: '園児を選択してください',
              quickReply: {
                items: [
                  {
                    type: 'action',
                    imageUrl: 'https://cdn4.iconfinder.com/data/icons/internet-seo-and-online-activity/400/Internet_online_world_wide_web_globe_network-512.png',
                    action: {
                      type: 'postback',
                      label: '太郎くん',
                      data: 'taro',
                      displayText: '太郎くんの連絡帳を入力します。'
                    }
                  },
                  {
                    type: 'action',
                    imageUrl: 'https://cdn4.iconfinder.com/data/icons/internet-seo-and-online-activity/400/Internet_online_world_wide_web_globe_network-512.png',
                    action: {
                      type: 'postback',
                      label: 'JIROくん',
                      data: 'jido'
                    }
                  },
                  {
                    type: 'action',
                    imageUrl: 'https://cdn4.iconfinder.com/data/icons/internet-seo-and-online-activity/400/Internet_online_world_wide_web_globe_network-512.png',
                    action: {
                      type: 'datetimepicker',
                      label: '時間を選ぶ',
                      data: 'hoge-time',
                      mode: 'time'
                    }
                  }
                ]
              }
            }
          end
          client.reply_message(event['replyToken'], message)
        when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
          response = client.get_message_content(event.message['id'])
          tf = Tempfile.open("content")
          tf.write(response.body)
        end
      when Line::Bot::Event::Postback
        message = {
          type: 'text',
          text: event['postback']['data']
        }
        client.reply_message(event['replyToken'], message)
      end
    }

    head :ok
  end
end
