namespace :feedback do
  desc 'Create XML File for all feedbacks'
  task xml_file: :environment do
    xml = Nokogiri::XML::Builder.new { |xml|
      xml.body do
        Feedback.includes(:user).all.each do |feedback|
          xml.send("feedback-#{feedback.id.to_s}") do
            xml.owner feedback.user.username
            xml.feedback_comment feedback.comment
            xml.rating feedback.entity_type == 'Post' ? feedback.entity.average_rating : '-'
            xml.type feedback.entity_type
          end
        end
      end
    }.to_xml

    File.open('public/feedbacks.xml', 'w') { |f| f.write(xml) }
  end
end
