shared_examples "a buildable job" do
  describe '.perform' do
    let(:job_args) do
      {
        "repository" => {
          "owner" => {
            "id" => 1234,
            "login" => "test",
            "type" => "Organization"
          }
        }
      }
    end
    let(:buildable_job) { described_class.new(job_args) }

    it "runs build runner" do
      build_runner = double(:build_runner, run: nil)
      payload = double("Payload")
      allow(Payload).to receive(:new).with(job_args).and_return(payload)
      allow(BuildRunner).to receive(:new).and_return(build_runner)

      buildable_job.perform_now

      expect(Payload).to have_received(:new).with(job_args)
      expect(BuildRunner).to have_received(:new).with(payload)
      expect(build_runner).to have_received(:run)
    end

    it "sends the exception to Sentry with the user_id" do
      exception = StandardError.new("something")
      allow(Payload).to receive(:new).and_raise(exception)
      allow(Raven).to receive(:capture_exception)

      buildable_job.perform_now

      expect(Raven).to have_received(:capture_exception).
        with(exception, payload: { data: job_args })
    end
  end
end
