require "rails_helper"

describe Comment do
  it { should belong_to :commentable }
  it { should belong_to :user }

  it { should validate_presence_of :content }
  it { should validate_presence_of :user_id }

  describe "#updated?" do
    it "returns false if the comment has never been updated" do
      comment = create :comment

      expect(comment.updated?).to eq false
    end

    it "returns true if the comment has been updated" do
      comment = create :comment
      comment.update!(content: "hi!")

      expect(comment.updated?).to eq true
    end
  end
end
