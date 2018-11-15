module Kiss
  class Operation
    def with(&block)
      WithContainer.new(self, block)
    end

    class WithSignalError < StandardError
    end

    class WithContainer
      attr_accessor :op, :with_block, :do_block, :else_block

      def initialize(op, with_block)
        @op = op
        @with_block = with_block
      end

      def call
        begin
          instance_eval(&with_block)
          do_res = instance_eval(&do_block)
        rescue WithSignalError => e
          else_res = instance_eval(&else_block)
        end

        self
      end

      def do(&block)
        @do_block = block
        self
      end

      def else(&block)
        @else_block = block
        self
      end

      def sig(signal, *args)
        puts '------'
        method_result = args.pop
        result_signal = method_result.shift
        puts "#{signal} == #{result_signal}"
        if signal != result_signal
          raise WithSignalError.new("Result signal is not ok | Signal: #{signal} != Result signal: #{result_signal}")
        end

        vars_hash = args.zip(method_result).to_h
        puts "VARS HASH: #{vars_hash}"

        vars_hash.each do |key, value|
          self.class.send(:attr_accessor, key.to_sym)
          instance_variable_set("@#{key}", value)
        end
      end

      # def ok(*args)
      #   sig(:ok, args)
      # end
    end
  end
end

class CreatePost < Kiss::Operation
  def call(params)
    res = with {
      sig :ok, :post_params, :smth, op.validate(params[:post])
      sig :ok, :post, :smth2, op.save(post_params, params[:wanna_fail])
      sig :ok, :notification, :smth3, op.notify(post[:id], smth, smth2)

      puts "Notifiucation: #{notification}"
    }.do {
      puts 'DO!'
    }.else {
      puts 'ELSE!'
    }.call

    puts '-RES-'
    puts res
    'OK RESULT'
  end

  def validate(params)
    [:ok, 1, 2]
  end

  def save(params, wanna_fail)
    wanna_fail ? [:fail, { msg: 'You made it yourself!'}] : [:ok, { id: 11 }, 4]
  end

  def notify(post_id, smth, smth2)
    [:ok, 5, 6]
  end
end

puts "OK op ================================="
CreatePost.new.call(a: 'b', wanna_fail: false)
puts 'FAIL op ==============================='
CreatePost.new.call(a: 'b', wanna_fail: true)
