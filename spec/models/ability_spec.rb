# encoding: utf-8

require 'spec_helper'

describe Ability do
  def part_for(node, options = {})
    Fabricate(:navigation_part, { :node => node }.merge(options))
  end

  let(:root_node) { Fabricate(:node, :context => root) }
  let(:node_1) { Fabricate(:node, :parent => root_node, :context => root) }
  let(:node_1_1) { Fabricate(:node, :parent => node_1, :context => root) }
  let(:node_2) { Fabricate(:node, :parent => root_node, :context => root) }

  context 'менеджер' do
    context 'корневого контекста' do
      subject { ability_for(manager_of(root)) }

      context 'управление контекстами' do
        it { should     be_able_to(:manage, root) }
        it { should     be_able_to(:manage, child_1) }
        it { should     be_able_to(:manage, child_1_1) }
        it { should     be_able_to(:manage, child_2) }
      end

      context 'управление нодами' do
        it { should     be_able_to(:manage, root_node) }
        it { should     be_able_to(:manage, node_1) }
        it { should     be_able_to(:manage, node_1_1) }
        it { should     be_able_to(:manage, node_2) }
      end

      context 'управление партами' do
        it { should     be_able_to(:manage, part_for(root_node, :region => 'content', :from_node => root_node)) }
        it { should     be_able_to(:manage, part_for(node_1, :region => 'content', :from_node => root_node)) }
      end

      context 'управление правами доступа' do
        it { should     be_able_to(:manage, another_manager_of(root).permissions.first) }
        it { should     be_able_to(:manage, another_manager_of(child_1).permissions.first) }
        it { should     be_able_to(:manage, another_manager_of(child_1_1).permissions.first) }
        it { should     be_able_to(:manage, another_manager_of(child_2).permissions.first) }
      end

      context 'управление сайтами' do
        it { should     be_able_to(:create, Site.new) }
      end
    end

    context 'вложенного контекста' do
      subject { ability_for(manager_of(child_1)) }

      let(:node_1) { Fabricate(:node, :parent => root_node, :context => child_1) }
      let(:node_1_1) { Fabricate(:node, :parent => node_1, :context => child_1) }

      context 'управление контекстами' do
        it { should_not be_able_to(:manage, root) }
        it { should     be_able_to(:manage, child_1) }
        it { should     be_able_to(:manage, child_1_1) }
        it { should_not be_able_to(:manage, child_2) }
      end

      context 'управление нодами' do
        it { should_not be_able_to(:manage, root_node) }
        it { should     be_able_to(:manage, node_1) }
        it { should     be_able_to(:manage, node_1_1) }
        it { should_not be_able_to(:manage, node_2) }
      end

      context 'управление партами' do
        it { should_not be_able_to(:manage, part_for(root_node, :region => 'content', :from_node => root_node)) }
        it { should     be_able_to(:manage, part_for(node_1, :region => 'content', :from_node => root_node)) }
        it { should     be_able_to(:manage, part_for(node_1_1, :region => 'content', :from_node => root_node)) }
      end

      context 'управление правами доступа' do
        it { should_not be_able_to(:manage, another_manager_of(root).permissions.first) }
        it { should     be_able_to(:manage, another_manager_of(child_1).permissions.first) }
        it { should     be_able_to(:manage, another_manager_of(child_1_1).permissions.first) }
        it { should_not be_able_to(:manage, another_manager_of(child_2).permissions.first) }
      end
    end

    context 'корневая нода' do
      subject { ability_for(manager_of(root_node))}

      context 'управление контекстами' do
        it { should_not be_able_to(:manage, root) }
        it { should_not be_able_to(:manage, child_1) }
        it { should_not be_able_to(:manage, child_1_1) }
        it { should_not be_able_to(:manage, child_2) }
      end

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

      context 'управление правами доступа' do
        it { should     be_able_to(:manage, another_manager_of(root_node).permissions.first) }
        it { should     be_able_to(:manage, another_manager_of(node_1).permissions.first) }
        it { should     be_able_to(:manage, another_manager_of(node_1_1).permissions.first) }
        it { should     be_able_to(:manage, another_manager_of(node_2).permissions.first) }
      end
    end

    context 'вложенная нода' do
      subject { ability_for(manager_of(node_1)) }

      context 'управление контекстами' do
        it { should_not be_able_to(:manage, root) }
        it { should_not be_able_to(:manage, child_1) }
        it { should_not be_able_to(:manage, child_1_1) }
        it { should_not be_able_to(:manage, child_2) }
      end

      context 'управление нодами' do
        it { should_not be_able_to(:manage, root_node) }
        it { should     be_able_to(:manage, node_1) }
        it { should     be_able_to(:manage, node_1_1) }
        it { should_not be_able_to(:manage, node_2) }
      end

      context 'управление партами' do
        it { should_not be_able_to(:manage, part_for(root_node, :region => 'content', :from_node => root_node)) }
        it { should     be_able_to(:manage, part_for(node_1, :region => 'content', :from_node => root_node)) }
        it { should     be_able_to(:manage, part_for(node_1_1, :region => 'content', :from_node => root_node)) }
        it { should_not be_able_to(:manage, part_for(node_2, :region => 'content', :from_node => root_node)) }
      end

      context 'управление правами доступа' do
        it { should_not be_able_to(:manage, another_manager_of(root_node).permissions.first) }
        it { should     be_able_to(:manage, another_manager_of(node_1).permissions.first) }
        it { should     be_able_to(:manage, another_manager_of(node_1_1).permissions.first) }
        it { should_not be_able_to(:manage, another_manager_of(node_2).permissions.first) }
      end
    end
  end

  context 'оператор' do
    context 'корневой ноды' do
      subject { ability_for(operator_of(root_node)) }

      context 'управление контекстами' do
        it { should_not be_able_to(:manage, root) }
        it { should_not be_able_to(:manage, child_1) }
        it { should_not be_able_to(:manage, child_1_1) }
        it { should_not be_able_to(:manage, child_2) }
      end

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

      context 'управление правами доступа' do
        it { should_not be_able_to(:manage, another_operator_of(root).permissions.first) }
        it { should_not be_able_to(:manage, another_operator_of(child_1).permissions.first) }
        it { should_not be_able_to(:manage, another_operator_of(child_1_1).permissions.first) }
        it { should_not be_able_to(:manage, another_operator_of(child_2).permissions.first) }
      end

      context 'управление сайтами' do
        it { should_not be_able_to(:create, Site.new) }
      end
    end

    context 'вложенной ноды' do
      subject { ability_for(operator_of(node_1)) }

      context 'управление контекстами' do
        it { should_not be_able_to(:manage, root) }
        it { should_not be_able_to(:manage, child_1) }
        it { should_not be_able_to(:manage, child_1_1) }
        it { should_not be_able_to(:manage, child_2) }
      end

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

      context 'управление правами доступа' do
        it { should_not be_able_to(:manage, another_manager_of(root).permissions.first) }
        it { should_not be_able_to(:manage, another_manager_of(child_1).permissions.first) }
        it { should_not be_able_to(:manage, another_manager_of(child_1_1).permissions.first) }
        it { should_not be_able_to(:manage, another_manager_of(child_2).permissions.first) }
      end
    end
  end
end
