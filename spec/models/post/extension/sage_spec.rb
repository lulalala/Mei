require 'rails_helper'

RSpec.describe Post::Extension::Sage do
  let(:board) { FactoryBot.create(:board) }
  let(:topic) { FactoryBot.create(:topic, board: board).reload }
  let(:post) { FactoryBot.create(:post, topic: topic) }

  it 'does not bump' do
    old_bumped_at = topic.bumped_at

    Timecop.freeze(5.seconds.from_now) do
      new_post = topic.posts.build
      new_post.assign_attributes(content: 'foo', options_raw: 'sage')
      new_post.save

      topic.reload.bumped_at.should == old_bumped_at
    end
  end
end
