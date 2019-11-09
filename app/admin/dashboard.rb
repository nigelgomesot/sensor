ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      messages = Message.all
      message_ids = messages.pluck(:id)

      column do
        panel 'Sentiment' do
          sentiments = Sentiment.where(message_id: message_ids).group(:level).count
          data = {
            'positive' => sentiments['positive'].to_i,
            'negative' => sentiments['negative'].to_i,
            'neutral' => sentiments['neutral'].to_i,
            'mixed' =>  sentiments['mixed'].to_i
          }
          colors = ['#00ff00', '#ff0000', '#cccccc', '#0000ff']

          pie_chart data, colors: colors, donut: true
        end
      end

      column span: 2 do
        panel 'Messages' do
          total_messages = messages.group_by_day(:sent_at).count
          positive_messages = messages.positive.group_by_day(:sent_at).count
          negative_messages = messages.negative.group_by_day(:sent_at).count

          line_chart [
            { name: :total,    data: total_messages, color: '#0000ff' },
            { name: :positive, data: positive_messages, color: '#00ff00' },
            { name: :negative, data: negative_messages, color: '#ff0000' }
          ]
        end
      end

      column do
        panel 'Top Categories' do
          bar_chart Entity.where(message_id: message_ids).group(:text).count
        end
      end
    end
  end # content
end
