require 'time'
require 'r509'
require 'dependo'
require 'rufus/scheduler'

#container module for the CADB checker
module R509::Validity::CADB
  # implements the R509::Validity interface for OpenSSL ca database (index) checking
  class Checker < R509::Validity::Checker
    include Dependo::Mixin

    def initialize(cadb_file_path)
      @cadb_file = cadb_file_path
      load_db

      @scheduler = Rufus::Scheduler.new

      @scheduler.every '10s' do
        if File.stat(@cadb_file).mtime.to_i > @cadb_last_refresh
          log.info("Change detected in '#{@cadb_file}', reloading.")
          load_db
        end
      end
    end

    # @return [R509::Validity::Status]
    def check(issuer,serial)
      raise ArgumentError.new('Serial must be provided') if serial.to_s.empty?

      cert_data = @cadb[serial.to_i]
      if cert_data.nil?
        return R509::Validity::Status.new(status: R509::Validity::UNKNOWN)
      end

      case cert_data[:status]
      when 'R'
        return R509::Validity::Status.new(
          status: R509::Validity::REVOKED,
          revocation_time: cert_data[:revocation_date],
          revocation_reason: cert_data[:revocation_reason]
        )
      when 'V'
        return R509::Validity::Status.new(:status => R509::Validity::VALID)
      else
        return R509::Validity::Status.new(status: R509::Validity::UNKNOWN)
      end
    end

    # openssl ca database format: http://pki-tutorial.readthedocs.org/en/latest/cadb.html
    # this can get memory intensive so we don't store fields we don't need.
    def load_db
      @cadb = {}
      @cadb_last_refresh = File.stat(@cadb_file).mtime.to_i

      File.open(@cadb_file).each do |line|
        status, expiration_date, revocation_info, serial, _, _ = line.chomp.split(/\t/)
        serial = serial.to_i(16)  # hex to decimal

        @cadb[serial] = {
          status: status,
          expiration_date: parse_time(expiration_date)
        }
        unless revocation_info == ''
          # revocation_info field (if not blank) format is: YYMMDDHHMMSSZ[,reason]
          revocation_date, reason = revocation_info.split(',')
          reason = reason.nil? ? OpenSSL::OCSP::REVOKED_STATUS_NOSTATUS : reason.to_i

          @cadb[serial][:revocation_date] = parse_time(revocation_date)
          @cadb[serial][:revocation_reason] = reason
        end
      end
    end

    # parse OpenSSL CA DB format dates into epoch. format: YYMMDDHHMMSSZ
    def parse_time(time_string)
      Time.strptime(time_string, '%y%m%d%H%M%S%Z').to_i
    end

    def is_available?
      true
    end
  end
end
