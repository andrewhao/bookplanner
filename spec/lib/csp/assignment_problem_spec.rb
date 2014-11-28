require "spec_helper"

describe AssignmentProblem do
  subject do
    described_class.new(sids, bids, history)
  end

  let(:sids) do
    (1..students).to_a.map{ |i| :"s#{i}" }
  end

  let(:bids) do
    (1..bags).to_a.map{ |i| :"b#{i}" }
  end

  let(:history) do
    sids.inject({}){ |acc, s| acc[s] = []; acc }
  end

  context "performance tests" do
    [[1, 1],
     [2, 2],
     [3, 3],
     [4, 4],
     [4, 5],
     [4, 6],
     [3, 100]].each do |students_count, bags_count|
      context "for #{students_count} s and #{bags_count} b" do
        let(:students) { students_count }
        let(:bags) { bags_count }

        it "performs in under 0.5s" do
          elapsed_time = Benchmark.realtime do
            subject.solve
          end

          expect(elapsed_time).to be < 0.5
        end
      end
    end
  end

  context "correctness checks" do
    [[3, 4],
     [2, 2]].each do |students_count, bags_count|

      context "for #{students_count} s and #{bags_count} b" do
        let(:students) { students_count }
        let(:bags) { bags_count }

        it "returns a plan" do
          expect(subject.solve).to_not be_empty
        end

        it "does not assign the same bags" do
          soln = subject.solve
          expect(soln.map(&:last).uniq.count).to eq soln.uniq.count
        end

        it "assigns bags to all students" do
          soln = subject.solve
          expect(soln.map(&:first).uniq).to match(sids)
        end
      end
    end
  end
end
