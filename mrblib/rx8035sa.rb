# coding: utf-8
# RTC: EPSON RX-8035SA
#
# I2C address : 0x32

class RX8035SA

  def initialize(i2c)
    @i2c = i2c
    @i2c.write(0x32, [0xE0, 0x00, 0x00])
    sleep 0.1
  end

  # RTC からの読み込み. 戻り値は数字の配列
  def read()
    a = @i2c.read(0x32, 7, 0x00).bytes   # 8 バイト分読み込み

    @time = Array.new
    i = 0
    [a[6], a[5], a[4], a[3], 0x3f & a[2], a[1], a[0]].each do |num|
      @time[i] = sprintf('%02x', num)
      i += 1
    end    

    return [@time[0].to_i, @time[1].to_i, @time[2].to_i, @time[3].to_i, @time[4].to_i, @time[5].to_i, @time[6].to_i]
  end

  # RTC への書き込み．引数は数字の配列
  def write( idate )
    date = Array.new
    
    # BCD データへの変換
    i = 0
    idate.each do |num|
      date[i] = (num / 10).to_i(2) << 4 | (num % 10).to_i(2)
      i += 1
    end
    
    @i2c.write(0x32, [0x00, date[6], date[5], 0x80 | date[4], date[3], date[2], date[1], date[0]])
    sleep 0.1
    @i2c.write(0x32, [0xF0, 0x00])
    sleep 0.1
  end

  def datetime
    read()
  end

  # 文字列で日付を戻す
  def str_date()
    return sprintf("%02d-%02d-%02d", @time[0], @time[1], @time[2]).to_s
  end

  # 文字列で時間を戻す
  def str_time()
    return sprintf("%02d:%02d:%02d", @time[4], @time[5], @time[6]).to_s
  end  

  # 文字列で日時を戻す
  def str_datetime()
    return sprintf("20%02d%02d%02d%02d%02d%02d", @time[0], @time[1], @time[2], @time[4], @time[5], @time[6]).to_s
  end

  # 時刻取得
  def year()
    return @time[0].to_i + 2000
  end

  def year2()
    return @time[0].to_i
  end

  def mon()
    return @time[1].to_i
  end

  def mday()
    return @time[2].to_i
  end

  def wday()
    return @time[3].to_i
  end

  def hour()
    return @time[4].to_i
  end

  def min()
    return @time[5].to_i
  end

  def sec()
    return @time[6].to_i
  end
  
end
