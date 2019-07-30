class IrisController
  require 'rmagick'
  require "open-uri"

  include Magick
  include Secured

  def check
    @user = session[:userinfo]
    @iris_url = get_iris_url
    @upload_url = get_upload_url
    @compare = compare(@upload_url, @iris_url)
  end

  private

  def get_iris_url
    @user = session[:userinfo]
    url = @user[:extra][:raw_info][:app_metadata][:iris_image_url]
    return url
  end

  def compare(iris_new, iris_stored)
    img1 = Magick::Image.read(iris_new).first

    impimg = ImageList.new(iris_stored)
    img2 = impimg.cur_image

    res = img1.compare_channel(img2, Magick::MeanAbsoluteErrorMetric, AllChannels)
    diff = res[1]
    w, h = img1.columns, img1.rows
    pixelcount = w * h
    perc = (diff * 100)
    percentage = perc/pixelcount

    return percentage
  end

  def get_upload_url
    dir = Dir.glob("public/uploads/iris/*").sort_by { |f| File.mtime(f) }.reverse
    return dir[1]
  end

end
