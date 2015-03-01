shared_examples "a retryable job" do
  describe '.perform' do
    let(:job_args) { {} }
    let(:retryable_job) { described_class.new(job_args) }

    it "retries when Resque::TermException is raised" do
      allow(retryable_job).to receive(:perform).and_raise(Resque::TermException.new(1))
      allow(retryable_job).to receive(:retry_job)

      retryable_job.perform_now

      expect(retryable_job).to have_received(:retry_job)
    end
  end
end