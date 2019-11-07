ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      # TODO: add scopes
      messages = Message.all

      column span: 2 do
        panel 'Comparisons' do
          # TODO: refactor
          today_total = messages.sent_today.count
          yesterday_total = messages.sent_yesterday.count
          last_week_total = messages.sent_last_week.count

          data = {
            today: {
              total: today_total,
              positive: ((messages.sent_today.positive.count.to_f/today_total) * 100),
              negative: ((messages.sent_today.negative.count.to_f/today_total) * 100),
            },
            yesterday: {
              total: yesterday_total,
              positive: ((messages.sent_yesterday.positive.count.to_f/yesterday_total) * 100),
              negative: ((messages.sent_yesterday.negative.count.to_f/yesterday_total) * 100),
            },
            last_week: {
              total: last_week_total,
              positive:((messages.sent_last_week.positive.count.to_f/last_week_total) * 100),
              negative: ((messages.sent_last_week.negative.count.to_f/last_week_total) * 100),
            }
          }
          render partial: 'comparisons', locals: { data: data }
        end

        panel 'Messages' do
          line_chart messages.group_by_day(:sent_at).count
        end
      end

      column do
        panel 'Top Categories' do
          bar_chart Entity.where(message_id: messages.map(&:id)).group(:text).count(:id)
        end
      end
    end
  end # content
end
