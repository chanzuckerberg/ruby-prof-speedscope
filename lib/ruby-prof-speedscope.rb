require 'json'

module RubyProf
  class SpeedscopePrinter < AbstractPrinter
    def frame_index(method)
      @frames ||= []
      @indexes ||= {} 

      index = @indexes[method]
      return index if !index.nil?

      name = "#{method.klass_name}##{method.method_name}"
      name += " *recursive*" if method.recursive?
      @frames << {
        name: name,
        file: method.source_file,
        line: method.line,
      }
      @indexes[method] = @frames.length - 1
    end

    def print_threads
      profiles = []
      @result.threads.each {|t| profiles << thread_profile(t)}
      @output << JSON.dump({
        "$schema": "https://www.speedscope.app/file-format-schema.json",
        exporter: "ruby-prof-speedscope",
        shared: {
          frames: @frames,
        },
        profiles: profiles,
      })
    end

    def thread_profile(thread)
      samples = []
      weights = []
      print_call_tree(thread.call_tree, []) do |sample, weight|
        samples << sample
        weights << weight
      end
      {
        type: 'sampled',
        name: "Thread: #{thread.id}, Fiber: #{thread.fiber_id}",
        unit: 'seconds',
        startValue: 0,
        endValue: thread.call_tree.measurement.total_time,
        samples: samples,
        weights: weights,
      }
    end

    def print_call_tree(call_tree, current_stack, &block)
      index = frame_index(call_tree.target)
      current_stack.push(index)
      if call_tree.self_time > 0
        block.call(current_stack.dup, call_tree.self_time)
      end
      call_tree.children.each do |child_tree|
        print_call_tree(child_tree, current_stack, &block)
      end
      current_stack.pop
    end
  end
end
