require "spec_helper"

describe AssignmentProblem do
  subject do
    described_class.new(sids, bids, history, debug: debug, logger: logger, template: template)
  end

  let(:debug) { false }
  let(:logger) { nil }#Proc.new {|msg| puts msg } }

  let(:sids) do
    (1..students_count).to_a.map{ |i| :"s#{i}" }
  end

  let(:bids) do
    (1..bags_count).to_a.map{ |i| :"b#{i}" }
  end

  let(:history) do
    sids.reduce({}){ |acc, s| acc[s] = []; acc }
  end

  let(:template) { {} }

  context 'for template' do
    let(:template) do
      { s1: :b1,
        s2: :b2 }
    end

    let(:students_count) { 2 }
    let(:bags_count) { 2 }

    it 'follows the template exactly when it can' do
      answer = subject.solve
      expect(answer).to match_array([[:s1, :b1],
                                     [:s2, :b2]])
    end

    context 'with a greater number of books' do
      let(:template) {
        { s1: :b5,
          s2: :b2 }
      }
      let(:bags_count) { 5 }

      it 'follows the template' do
        expect(subject.solve).to match_array [[:s1, :b5], [:s2, :b2]]
      end
    end

    context 'when history is incompatible with the template' do
      let(:template) {
        { s1: :b1,
          s2: :b2 }
      }

      let(:history) {
        { s1: [:b1], s2: [] }
      }
      let(:bags_count) { 3 }

      it 'relaxes a constraint on the template' do
        expect(subject.solve).to match_array [[:s2, :b2], [:s1, :b3]]
      end
    end

    context 'when student 3 returns a book and joints a templated plan that is fundamentally incompatible' do
      let(:template) {
        { s2: :b1,
          s1: :b2 }
      }

      let(:history) {
        { s1: [:b1], s2: [:b2], s3: [:b3] }
      }
      let(:students_count) { 3 }
      let(:bags_count) { 3 }

      it 'relaxes both constraints on the template' do
        expect(subject.solve).to match_array [[:s1, :b2],
                                              [:s2, :b3],
                                              [:s3, :b1]]
      end
    end
  end

  context "for histories" do
    let(:students_count) { 4 }
    let(:bags_count) { 5 }
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
        let(:students_count) { students_count }
        let(:bags_count) { bags_count }

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
        let(:students_count) { students_count }
        let(:bags_count) { bags_count }

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
