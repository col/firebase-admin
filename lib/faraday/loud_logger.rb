require 'faraday'

# @private
module FaradayMiddleware
  # @private
  class LoudLogger < Faraday::Middleware
    extend Forwardable
    def_delegators :@logger, :debug, :info, :warn, :error, :fatal

    def initialize(app, options = {})
      super
      @app = app
      @logger = options.fetch(:logger) do
        require 'logger'
        ::Logger.new($stdout)
      end
    end

    def call(env)
      start_time = Time.now
      info  { request_info(env) }
      debug { request_debug(env) }
      @app.call(env).on_complete do
        end_time = Time.now
        response_time = end_time - start_time
        info  { response_info(env, response_time) }
        debug { response_debug(env) }
      end
    end

    private

    def filter(output)
      output
    end

    def request_info(env)
      format('Started %<method>s request to: %<url>s', method: env[:method].to_s.upcase, url: filter(env[:url]))
    end

    def response_info(env, response_time)
      format(
        'Response from %<method>s; Status: %<status>d; Time: %<time>.1fms',
        method: env[:method].to_s.upcase,
        status: env[:status],
        time: (response_time * 1_000.0)
      )
    end

    def request_debug(env)
      debug_message('Request', env[:request_headers], env[:body])
    end

    def response_debug(env)
      debug_message('Response', env[:response_headers], env[:body])
    end

    def debug_message(name, headers, body)
      <<-MESSAGE.gsub(/^ +([^ ])/m, '\\1')
      #{name} Headers:
      ----------------
      #{format_headers(headers)}

      #{name} Body:
      -------------
      #{filter(body)}
      MESSAGE
    end

    def format_headers(headers)
      length = headers.map { |k, _| k.to_s.size }.max
      headers.map { |name, value| "#{name.to_s.ljust(length)} : #{filter(value)}" }.join("\n")
    end
  end
end
