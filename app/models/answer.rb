class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :comments
  has_many :votes, as: :voteable
  before_save :answer_scraper

  # SHADI REVIEW: don't user question_id or *_id, try to use the name of the association.
  # so this line would be attr_accessible :url, :content, :question, :user
  # now when you mass assign: Answer.new :user => current_user, :question => @question.
  attr_accessible :url, :content, :question_id, :user_id

  validates :url, presence: true

  default_scope order('created_at DESC')

  def best?
    self.id == self.question.best_answer 
  end

  def vote_count 
    self.votes.inject(0) { |result, vote| result + vote.value}
  end

  def answer_scraper
    agent = Mechanize.new
    agent.get(self.url)
    self.picture_url = agent.page.search("#main-image").first.attributes['src'].value
    mech_objs = agent.page.search("h1").children
    self.product_name = mech_objs.length > 1 ? mech_objs[-2].text() : mech_objs.text()
  end
end
