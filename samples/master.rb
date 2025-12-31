# coding: utf-8

#I2C 初期化
i2c = I2C.new()

## RTC 初期化. 時刻設定
rtc = RX8035SA.new(i2c)

# RTC に初期値書き込み
rtc.write([20, 3, 31, 1, 23, 59, 40]) #年(下2桁), 月, 日, 曜日, 時, 分, 秒

# 適当な時間を表示
while true
  rtc.read  #時刻の読み出し
  t0 = sprintf("%02d-%02d-%02d", rtc.year - 2000, rtc.mon, rtc.mday)
  t1 = sprintf("%02d:%02d:%02d", rtc.hour, rtc.min, rtc.sec)

  puts sprintf("#{t0} #{rtc.wday} #{t1}")
  sleep 1
end
