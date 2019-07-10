control 'network-tools' do
    %w(
        dig
        host
        ping
    ).each do |package|
        describe command(package) do
            it { should exist }
        end
    end
end