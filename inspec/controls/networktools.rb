control 'network-tools' do
    %w(
        curl
        dig
        host
        http
        ping
    ).each do |package|
        describe command(package) do
            it { should exist }
        end
    end
end