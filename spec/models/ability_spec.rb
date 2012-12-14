# encoding: utf-8

require 'spec_helper'

describe Ability do
  def part_for(node, options = {})
    Fabricate(:navigation_part, { :node => node }.merge(options))
  end

  let(:root_node) { Fabricate(:node) }
  let(:node_1) { Fabricate(:node, :parent => root_node) }
  let(:node_1_1) { Fabricate(:node, :parent => node_1) }
  let(:node_2) { Fabricate(:node, :parent => root_node) }

  context 'менеджер' do
    subject { ability_for(manager)}

    context 'управление нодами' do
      it { should     be_able_to(:manage, root_node) }
      it { should     be_able_to(:manage, node_1) }
      it { should     be_able_to(:manage, node_1_1) }
      it { should     be_able_to(:manage, node_2) }
    end

    context 'управление партами' do
      it { should     be_able_to(:manage, part_for(root_node, :region => 'content', :from_node => root_node)) }
      it { should     be_able_to(:manage, part_for(node_1, :region => 'content', :from_node => root_node)) }
      it { should     be_able_to(:manage, part_for(node_1_1, :region => 'content', :from_node => root_node)) }
      it { should     be_able_to(:manage, part_for(node_2, :region => 'content', :from_node => root_node)) }
    end

    context 'управление сайтами' do
      it { should     be_able_to(:create, Site.new) }
    end
  end

  context 'оператор' do
    context 'корневой ноды' do
      subject { ability_for(operator_of(root_node)) }

      context 'управление нодами' do
        it { should     be_able_to(:manage, root_node) }
        it { should     be_able_to(:manage, node_1) }
        it { should     be_able_to(:manage, node_1_1) }
        it { should     be_able_to(:manage, node_2) }
      end

      context 'управление партами' do
        it { should     be_able_to(:manage, part_for(root_node, :region => 'content', :from_node => root_node)) }
        it { should     be_able_to(:manage, part_for(node_1, :region => 'content', :from_node => root_node)) }
        it { should     be_able_to(:manage, part_for(node_1_1, :region => 'content', :from_node => root_node)) }
        it { should     be_able_to(:manage, part_for(node_2, :region => 'content', :from_node => root_node)) }
      end

      context 'управление сайтами' do
        it { should_not be_able_to(:create, Site.new) }
      end
    end

    context 'вложенной ноды' do
      subject { ability_for(operator_of(node_1)) }

      context 'управление нодами' do
        it { should_not be_able_to(:manage, root_node) }
        it { should     be_able_to(:manage, node_1) }
        it { should     be_able_to(:manage, node_1_1) }
        it { should_not be_able_to(:manage, node_2) }
      end

      context 'управление партами' do
        it { should_not be_able_to(:manage, part_for(root_node, :region => 'content', :from_node => root_node)) }
        it { should_not be_able_to(:manage, part_for(node_2, :region => 'content', :from_node => root_node)) }
        it { should     be_able_to(:manage, part_for(node_1, :region => 'content', :from_node => root_node)) }
        it { should     be_able_to(:manage, part_for(node_1_1, :region => 'content', :from_node => root_node)) }
      end
    end
  end
end
