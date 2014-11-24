require "spec_helper"

describe PlanGenerator do
  describe "#generate" do
    context "for a minimal constraint problem" do
      let(:student1) { FactoryGirl.create(:student) }
      let(:student2) { FactoryGirl.create(:student) }
      let(:bag1) { FactoryGirl.create(:book_bag) }
      let(:bag2) { FactoryGirl.create(:book_bag) }

      let(:students) { [student1, student2] }
      let(:bags) { [bag1, bag2] }

      subject { described_class.new(students, bags) }

      context "for direct assignment" do
        before do
          expect(student1).to receive(:past_assignments).and_return([double(:book_bag_id => bag1.id)])
          expect(student2).to receive(:past_assignments).and_return([double(:book_bag_id => bag2.id)])
        end

        it "returns assignments that satisfy constraints properly" do
          assns = subject.generate

          assn1 = assns.detect{ |a| a.student == student1 && a.book_bag == bag2 }
          assn2 = assns.detect{ |a| a.student == student2 && a.book_bag == bag1 }

          expect(assn1).to be_a Assignment
          expect(assn2).to be_a Assignment
        end
      end

      context "for different bag histories" do
        before do
          expect(student1).to receive(:past_assignments).and_return([double(:book_bag_id => bag2.id)])
          expect(student2).to receive(:past_assignments).and_return([double(:book_bag_id => bag1.id)])
        end

        it "returns correct assignment" do
          assns = subject.generate
          assn1 = assns.detect{ |a| a.student == student1 && a.book_bag == bag1 }
          assn2 = assns.detect{ |a| a.student == student2 && a.book_bag == bag2 }

          expect(assn1).to be_a Assignment
          expect(assn2).to be_a Assignment
        end
      end

      context "for insufficient bags" do
        let(:bags) { [bag1] }

        before do
          expect(student1).to receive(:past_assignments).and_return([double(:book_bag_id => bag2.id)])
          expect(student2).to receive(:past_assignments).and_return([double(:book_bag_id => bag1.id)])
        end

        it "raises exception" do
          expect{subject.generate}.to raise_error(PlanGenerator::NoPlanFound)
        end
      end

      context "for impossible constraints with bookwormy students" do
        before do
          expect(student1).to receive(:past_assignments).and_return([double(:book_bag_id => bag1.id), double(:book_bag_id => bag2.id)])
          expect(student2).to receive(:past_assignments).and_return([double(:book_bag_id => bag1.id)])
        end

        it "raises exception" do
          expect {
            subject.generate
          }.to raise_error(PlanGenerator::NoPlanFound)
        end
      end

      context "for more bags than students" do
        let(:bag3) { FactoryGirl.create(:book_bag) }
        let(:bags) { [bag1, bag2, bag3] }

        it "generates assignments" do
          expect(subject.generate).to be_all{ |b| b.is_a?(Assignment) }
        end
      end
    end
  end
end
