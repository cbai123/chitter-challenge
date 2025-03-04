require 'peep_repository'
require 'peep'
require 'database_connection'

def reset_peeps_table
  seed_sql = File.read('seeds/seeds_peeps.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
  connection.exec(seed_sql)
end

describe PeepRepository do
  before(:each) do 
    reset_peeps_table
  end

  # 1
  it "Get all peeps" do
    repo = PeepRepository.new

    peeps = repo.all

    expect(peeps.length).to eq 3

    expect(peeps[0].id).to eq 1
    expect(peeps[0].message).to eq 'message1'
    expect(peeps[0].user_id).to eq 1

    expect(peeps[1].id).to eq 2
    expect(peeps[1].message).to eq 'message2'
    expect(peeps[1].time).to eq '2022-02-20 02:01:01'

    expect(peeps[2].id).to eq 3
    expect(peeps[2].user_id).to eq 2
  end

  # 2
  it "Get a single peep" do
    repo = PeepRepository.new

    peep = repo.find(3)

    expect(peep.id).to eq 3
    expect(peep.message).to eq 'message3'
    expect(peep.time).to eq '2022-03-30 03:01:01'
    expect(peep.user_id).to eq 2
  end

  # 3
  it "Create a peep" do
    new_peep = Peep.new
    new_peep.message = 'message4'
    new_peep.time = '2022-04-10 04:04:04'
    new_peep.user_id = 1

    repo = PeepRepository.new
    repo.create(new_peep)

    peeps = repo.all

    expect(peeps.length).to eq 4
    expect(peeps[-1].message).to eq 'message4'
  end
end
