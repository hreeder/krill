control 'database-tools' do
    %w(
        pg_dump
        pg_restore
        psql
    ).each do |package|
        describe command(package) do
            it { should exist }
        end
    end
end