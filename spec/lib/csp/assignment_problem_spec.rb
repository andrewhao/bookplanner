require "spec_helper"

describe AssignmentProblem do
  subject do
    described_class.new(sids, bids, history, debug: debug, logger: logger)
  end

  let(:debug) { false }
  let(:logger) { Proc.new {|msg| puts msg } }

  let(:sids) do
    (1..students).to_a.map{ |i| :"s#{i}" }
  end

  let(:bids) do
    (1..bags).to_a.map{ |i| :"b#{i}" }
  end

  let(:history) do
    sids.inject({}){ |acc, s| acc[s] = []; acc }
  end

  context "for histories" do
    let(:students) { 4 }
    let(:bags) { 5 }
    let(:history) do
      {:s1 => [:b1, :b2],
       :s2 => [:b2, :b1],
       :s3 => [:b3, :b4],
       :s4 => [:b4, :b3]}
    end

    it "generates a plan" do
      answer = subject.solve
      expect(answer).to_not be_empty
    end

    context "for complicated bags and histories" do
      let(:sids) do
        [61, 63, 64, 65, 66, 73, 83, 84, 78]
      end

      let(:bids) do
        [128, 130, 131, 132, 133, 134, 135, 136, 183]
      end

      let(:history) do
        {61=>[128, 130],
         63=>[130, 128],
         64=>[131, 132],
         65=>[132, 131],
         66=>[133, 134],
         73=>[134, 133],
         83=>[135, 136],
         84=>[136, 135],
         78=>[183]}
      end

      it "generates a plan" do
        expect(subject.solve).to_not be_empty
      end
    end
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

    context "for no students or bags" do
      let(:sids) { [] }
      let(:bids) { [] }

      it "raises exception" do
        expect {
          subject.solve
        }.to raise_error(Amb::ExhaustedError)
      end
    end

    context "for one student but no bags" do
      let(:sids) { [1] }
      let(:bids) { [] }

      it "raises exception" do
        expect {
          subject.solve
        }.to raise_error(Amb::ExhaustedError)
      end
    end
  end
end
