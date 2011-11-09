class HtmlPart < Part
  belongs_to :content

  validates_presence_of :content

  before_validation :create_or_update_content

  delegate :body, :to => :content, :allow_nil => true

  def body=(body)
    @body = body
  end

  private
    def create_or_update_content
      self.content ? self.content.update_attribute(:body, @body) : self.content = Content.create!(:body => @body)
    end
end

# == Schema Information
#
# Table name: parts
#
#  id         :integer         not null, primary key
#  content_id :integer
#  page_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  region     :string(255)
#  type       :string(255)
#

