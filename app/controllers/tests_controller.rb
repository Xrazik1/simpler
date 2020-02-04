class TestsController < Simpler::Controller

  def index
    status 202
    headers['Content-Type'] = 'text/plain'

    #render plain: "plain renderer"
    #render html: "<span style='color: red'>html renderer</span>"
    #render json: { json: 'renderer' }


    @time = Time.now
  end

  def show
    @test = Test[params['id']]
  end

end
