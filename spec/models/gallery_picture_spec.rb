require 'spec_helper'

describe GalleryPicture do
  it { should belong_to :gallery_part }
  it { should validate_presence_of :description }
  it { should validate_presence_of :picture_url }

  context 'sending queue messages' do
    let(:page) { Fabricate :page }
    let(:gallery_part) { Fabricate(:gallery_part, :node => page) }
    subject { Fabricate :gallery_picture, :gallery_part => gallery_part }
    alias :create_subject :subject

    describe '.create' do
      before { MessageMaker.should_receive(:make_message).with('esp.cms.storage', 'lock',
                                                               :url => "http://example.com/ru/name/#region#1",
                                                               :storage_url => "http://storage.esp.url/files/1.png") }
      specify { create_subject }
    end

    describe '#update' do
      before { create_subject }
      context 'picture_url updated' do
        before { MessageMaker.should_receive(:make_message).with('esp.cms.storage', 'unlock',
                                                                 :url => "http://example.com/ru/name/#region#1",
                                                                 :storage_url => "http://storage.esp.url/files/1.png") }
        before { MessageMaker.should_receive(:make_message).with('esp.cms.storage', 'lock',
                                                                 :url => "http://example.com/ru/name/#region#1",
                                                                 :storage_url => "http://storage.esp.url/files/2.png") }
        specify { subject.update_attribute :picture_url, 'http://storage.esp.url/files/2.png' }
      end
      context 'description updated' do
        before { MessageMaker.should_not_receive(:make_message) }
        specify { subject.update_attribute :description, 'Photo description' }
      end
    end

    describe '#destroy' do
      before { create_subject }
      before { MessageMaker.should_receive(:make_message).with('esp.cms.storage', 'unlock',
                                                               :url => "http://example.com/ru/name/#region#1",
                                                               :storage_url => "http://storage.esp.url/files/1.png") }
      specify { subject.destroy }
    end
  end
end
