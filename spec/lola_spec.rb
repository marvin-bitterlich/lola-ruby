require 'spec_helper'
require 'hashie'

RSpec.describe Lola do
  describe 'general lola module' do
    it 'has a version number' do
      expect(Lola::VERSION).not_to be nil
    end

    it 'monkey patches Symbol' do
      ensure_that :s.respond_to? :query_inspect
      ensure_that Symbol.include? Lola::Joinable
    end
  end


  describe 'query building' do
    describe 'smoke tests' do
      it 'does not raise any exception on basic +' do
        :s + :d
      end

      it 'does not raise any exception on basic -' do
        :s + :d
      end

      it 'does not raise any exception on chained queries' do
        :s + :d + :x + :something
      end

      it 'does not raise any exception on being inspected' do
        (:s + :d).inspect
      end

      it 'does not raisa any exception on custom operator ⇒' do
        :d.⇒(:hehe)
      end
    end

    describe 'query string tests' do
      it 'can print (s + d)' do
        expect(
          (:s + :d).inspect
        ).to eq '(s + d)'
      end

      it 'can print (s - d)' do
        expect(
          (:s - :d).inspect
        ).to eq '(s - d)'
      end

      it 'can print (s ⇒ d)' do
        expect(
          (:s.⇒ :d).inspect
        ).to eq '(s ⇒ d)'
      end

      it 'can print (((s + d) + x) + something)' do
        expect(
          (:s + :d + :x + :something).inspect
        ).to eq '(((s + d) + x) + something)'
      end

      it 'can print ((s + d) + (x + something))' do
        expect(
          ((:s + :d) + (:x + :something)).inspect
        ).to eq '((s + d) + (x + something))'
      end
    end
  end

  describe 'query evaluation' do
    describe 'smoke tests' do
      it 'does not raise any exceptions on basic +' do
        (:s + :d).evaluate(s: 1, d: 2)
      end

      it 'does not raise any exceptions on basic -' do
        (:s - :d).evaluate(s: 1, d: 2)
      end

      it 'does not raise any exceptions on method uses' do
        (:s - :d).evaluate(Hashie::Mash.new s: 1, d: 2)
      end

      it 'allows static variables' do
        (:s - 2).evaluate(s: 1)
      end

      it 'raises evaluate errors on type problems' do
        expect {
          (:s + :d).evaluate(s: 1, d: 'd')
        }.to raise_error Lola::EvaluationError
      end

      it 'raises evaluate errors on operator problems' do
        expect {
          (:s.⇒ :d).evaluate(s: 1, d: 1)
        }.to raise_error Lola::EvaluationError
      end
    end

    describe 'result tests' do
      it 'calculates 1 + 2 = 3' do
        expect(
          (:s + :d).evaluate(s: 1, d: 2)
        ).to be 3
      end
    end
  end

  describe 'DSL' do
    describe 'smoke tests' do
      it 'does basic things' do
        Lola.spec do
          define :s, :numeric do
            1
          end
          define :d, :numeric do
            5
          end
          define :something, :numeric do
            (:s + :d)
          end
        end
      end
      it 'does not allow double assign' do
        expect {
          Lola.spec do
            define :something, :numeric do
              1
            end
            define :something, :numeric do
              2
            end
          end
        }.to raise_error Lola::MappingError
      end
      it 'does a trigger' do
        Lola.spec do
          define :something, :boolean do
            3 > 5
          end
          trigger :something
        end
      end
      it 'does not allow empty trigger' do
        expect {
          Lola.spec do
            trigger :something
          end
        }.to raise_error Lola::MappingError
      end
      it 'does a look back' do
        Lola.spec do
          define :s, :numeric do
            1
          end
          define :something, :boolean do
            (:s + 1) > look_back(:s, 1, 1)
          end
        end
      end
    end

    describe 'store tests' do
      it 'does basic things' do
        spec = Lola.spec do
          define :s, :numeric do
            1
          end
          define :d, :numeric do
            5
          end
          define :something, :numeric do
            (:s + :d)
          end
        end
        expect(spec.print(:something)).to eq '(s + d)'
      end
      it 'does a trigger' do
        spec = Lola.spec do
          define :s, :numeric do
            1
          end
          define :d, :numeric do
            5
          end
          define :something, :boolean do
            (:s + :d) > 5
          end
          trigger :something
        end
        expect(spec.trigger? :something).to be_truthy
      end
      it 'does not set triggers all the time' do
        spec = Lola.spec do
          define :s, :numeric do
            1
          end
          define :d, :numeric do
            5
          end
          define :something, :boolean do
            (:s + :d) > 5
          end
        end
        expect(spec.trigger? :something).to be_falsey
      end
      it 'does a look back' do
        spec = Lola.spec do
          define :s, :numeric do
            1
          end
          define :d, :numeric do
            5
          end
          define :something, :boolean do
            (:s + :d) > look_back(:s, 1, 1)
          end
        end
        expect(spec.print(:something)).to eq '((s + d) > look_back(s, 1, 1))'
      end
    end

    describe 'evaluation tests' do
      it 'does basic constants' do
        spec = Lola.spec do
          define :something, :numeric do
            1
          end
          define :x, :numeric do
            look_back(:something, 1, -51)
          end
        end
        expect(spec.evaluate).to be_truthy
        expect(spec.evaluate).to be_truthy
      end
      it 'does basic triggers' do
        expect {
          spec = Lola.spec do
            define :something, :numeric do
              1
            end
            trigger :something
          end
          expect(spec.evaluate).to be_truthy
        }.to raise_error Lola::TriggerError
      end
      it 'does complex triggers' do
        expect {
          spec = Lola.spec do
            define :one, :numeric do
              1
            end
            define :count, :numeric do
              look_back(:count, 1, 0) + :one
            end
            define :limit_reached, :boolean do
              :count > 3
            end
            trigger :limit_reached, 'Limit reached!'
          end
          spec.evaluate # count => 1
          spec.evaluate # count => 2
          spec.evaluate # count => 3
          puts spec.inspect
          spec.evaluate # count => 4 ⇒ error
        }.to raise_error Lola::TriggerError
      end
    end

=begin
    describe 'usage tests' do

      class Balance
        Lola.spec do
          define :difference do
            look_back(:balance, 1, 0) - :balance
          end
          define :big_deduction do
            look_back(:balance, 1, 0) / 100
          end
          define :on_hold do
            :difference > :big_deduction
          end
          trigger :on_hold
        end

        attr_accessor :balance

        def send(to, amount)
          raise 'on hold!' if amount > (balance / 100)
          self.balance -= amount
          self.save # error happens here
          to.receive(balance)
        end
      end
      it 'does a big transaction that should be on hold' do
        balance = Balance.new
        balance.balance = 1000
        balance.save
        balance.send(Balance.new, 100)
      end
    end
=end
  end

  describe 'Rails' do
    describe 'smoke tests' do
      it 'does basic things' do
        Lola::ClassCallback.around_create((:s + :d) > 5)
      end
    end
  end
end
