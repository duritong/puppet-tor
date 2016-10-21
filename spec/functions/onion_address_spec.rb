require 'spec_helper'

describe 'onion_address' do
  describe 'signature validation' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /requires 1 argument/) }
    it { is_expected.to run.with_params(1,2).and_raise_error(Puppet::ParseError, /requires 1 argument/) }
  end

  describe 'normal operation' do
    it { is_expected.to run.with_params(
"-----BEGIN RSA PRIVATE KEY-----
MIICXAIBAAKBgQC9OUBOkL73n43ogC/Jma54/ZZDEpoisqpkGJHgbcRGJIxcqqfL
PbnT3hD5SUCVXxLnzWDCTwTe2VOzIUlBXmslwVXnCJh/XGZg9NHiNU3EAZTwu1g9
8gNmmG1bymaoEBkuC1osijOj+CN+gzLzApiMbDxddpxTn70LWaSqMDbfdQIDAQAB
An88nBn9EGAa8QCDeIvWB2PbXV7EHTFB6/ioFzairIYx8YMEK6WTdDIRqw/EybHm
Jo3nseFMXAMzXmlw9zh/t76ZzE7ooYocSPIEzpu4gDRsa5/mqRCGajs8A8ooiHN5
Tc9cHzIfhjOYhu3VxF0G9LTAC8nKdWQkHm+h+J6A6+wBAkEA2E6GcIdPGTSfaNRS
BHOpKUUSvH7W0e5fyYe221EhESdTFjVkaO5YN9HvcqYh27nik0azKgNj6PiE01FC
0q4fgQJBAN/ycGS3dX5WRXEOpbQ04LKyxCFMVgS+tN5ueDgbv/SxWAxidLYcVfbg
CcUA+L2OaQ95S97CxYlCLda10vIPOfUCQQCUvQJzFIgOlAHdqsovJ3011Lp6hVmg
h6K0SK8zhkkPq5PVnKdMBEEDOUfG9XgoyFyF20LN7ADirSlgyesCRhuBAkEAmuCE
MmNecn0fkUzb9IENVQik85JjeuyZEau8oLEwU/3CMu50YO2/1fijSQee/xlaN0Vf
3zM8geyu3urodFdrcQJBAMBcecMvo4ddZ/GnwpKJuXEhKSwQfPOeb8lK12NvKuVE
znq+qT/KbJlwy/27X/auCAzD5rJ9VVzyWiu8nnwICS8=
-----END RSA PRIVATE KEY-----"
    ).and_return("drpsyff5srkctr7h")}
  end
  describe 'by getting an RSA key' do
    it { is_expected.to run.with_params(OpenSSL::PKey::RSA.new(
"-----BEGIN RSA PRIVATE KEY-----
MIICXQIBAAKBgQDbvYjbtJB9vTnEygyq4Bzp0xxtTl3ZYKC6JbxgRzP8uLv1HoxX
20EmQUZ/LNBXHebc6frlObhtpKULFuBzAy5LpdKI9CUErkl3D3AigFgP3XP/PtdP
m11TuxdBoKL6Jbo54NpUVOGQ5SJJaNEOfhmgMSCtlyyI9DBni3PLO2P0sQIDAQAB
AoGAPTlt7Gk+6QnUErSJGwMeize67+mp1GtL3RGujtTH8141YHKGf+QjHtmJHt4J
nnxCWsMGmN+gN0xsf8578w+r0fvDjZ3e5lVUpR/8ds90a654Lr/pgqLc3H1EZ9Pr
GDFjPdaMtdTSX5hSAB2EDLfDUU19bdFRK+k71mglrMLpdQECQQDmJt3mmX67kAzH
w2I/BEbmOlonmn3c98VyawoNrk0fKAluoYWHxxk9SuCu2ZDQyyPKPQuZbgdPnUNp
kV3PuQ6ZAkEA9GtTjMfceX8ArLTmOMIMVP2t8yzbcK2uqukMG79JiPZbYKIstjho
XUpO/jZhTb9p8M4NV/09z091gMTOF6Fd2QJBAM1I7bS6ROhX3I5yIDfFQNgqRC//
BTULa/par2T0i6W2uHMNb2VkmYaqOy66sQkLqKjDOo1oLu08gNyw5NRbZEECQQCr
FDR25a28nNisCjLap3haRPXssAko5WjM2DJReaLO6yEqklkZcoIaSljgNtAEy2Yr
1w4f+HG7GbL1XsuiXqCBAkAeYljaIVhqGOOez0ORaCm0FCLoTJ6/fn7009os/qgr
n2xsVGUNm+E0pvAMT0LIx2KvpLxe2Y0Xx497/vyM6e7G
-----END RSA PRIVATE KEY-----")
    ).and_return("d3ep6pcs4to4hbwo") }
  end
end
