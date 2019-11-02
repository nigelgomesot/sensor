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
              total: messages.count,
              negative: messages.count,
            },
            yesterday: {
              total: messages.count,
              negative: messages.count,
            },
            last_week: {
              total: messages.count,
              negative: messages.count,
            }
          }
          render partial: 'comparisons', locals: { data: data }

        end
        panel 'Messages' do
          line_chart messages.group_by_day(:sent_at).count
        end
      end
      column  do
        panel 'Top Categories' do
          bar_chart Entity.where(message_id: messages.map(&:id)).group(:text).count(:id)
        end
      end
    end
  end # content
end
