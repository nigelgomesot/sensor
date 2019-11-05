ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      # TODO: add scopes
      messages = Message.all

      column span: 2 do
        panel 'Comparisons' do
          data = {
            today: {
              total: messages.sent_today.count,
              negative: messages.sent_today.negative.count,
            },
            yesterday: {
              total: messages.sent_yesterday.count,
              negative: messages.sent_yesterday.negative.count,
            },
            last_week: {
              total: messages.sent_last_week.count,
              negative: messages.sent_last_week.negative.count,
            }
          }
          render partial: 'comparisons', locals: { data: data }
        end

        panel 'Messages' do
          line_chart messages.group_by_day(:sent_at).count
        end
      end

      column do
        panel 'Sentiment' do
          sentiments = Sentiment.where(message_id: messages.map(&:id))
          total_count = sentiments.count.to_f
          group_count = sentiments.group(:level).count
          data = {
            positive: ((group_count['positive'].to_f/total_count) * 100).round(2),
            negative: ((group_count['negative'].to_f/total_count) * 100).round(2),
            neutral:  ((group_count['neutral'].to_f/total_count) * 100).round(2),
            mixed:    ((group_count['mixed'].to_f/total_count) * 100).round(2),
          }
          render partial: 'sentiments', locals: { data: data }
        end

        panel 'Top Categories' do
          bar_chart Entity.where(message_id: messages.map(&:id)).group(:text).count(:id)
        end
      end
    end
  end # content
end
