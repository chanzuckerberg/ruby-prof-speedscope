require 'json'

module RubyProf
  class SpeedscopePrinter < AbstractPrinter
    def print_threads
      profiles = []
      @output << <<~HEADER
      {
        "$schema": "https://www.speedscope.app/file-format-schema.json",
        "exporter": "ruby-prof-speedscope",
        "shared": {
          "frames": [
      HEADER

      frames = {}
      frame_index = 0
      @result.threads.each do |thread|
        thread.methods.each_with_index do |method, idx|
          next if frames.has_key?(method.object_id)
          name = "#{method.klass_name}##{method.method_name}"
          name += " *recursive*" if method.recursive?
          @output << <<~FRAME
            {
              "name": "#{name}",
              "file": "#{method.source_file}",
              "line": "#{method.line}"
            },
          FRAME
          frames[method.object_id] = frame_index
          frame_index += 1
        end
      end

      @output << <<~FRAMES
        {"name": "dummy_trailing_comma"}
        ]
        },
        "profiles": [
      FRAMES

      @result.threads.each_with_index do |thread, idx|
        @output << <<~PROFILES
          {
            "type": "evented",
            "name": "Thread: #{thread.id}, Fiber: #{thread.fiber_id}",
            "unit": "seconds",
            "startValue": 0,
            "endValue": #{JSON.dump(thread.call_tree.measurement.total_time)},
            "events": [
        PROFILES
        print_call_tree(thread.call_tree, frames, 0.0, true)
        @output << <<~PROFILES
          ]
          }#{idx < @result.threads.length - 1 ? "," : ""}
        PROFILES
      end

      @output << <<~ENDING
        ]
        }
      ENDING
    end

    def print_call_tree(call_tree, frames, start_time, root = false)
      @output << <<~BEGINEVENT
        {
          "type": "O",
          "frame": #{frames[call_tree.target.object_id]},
          "at": #{JSON.dump(start_time)}
        },
      BEGINEVENT

      original_start_time = start_time
      start_time += call_tree.self_time
      call_tree.children.each do |child_tree|
        next if child_tree.total_time < 0
        print_call_tree(child_tree, frames, start_time)
        start_time += child_tree.total_time
      end

      @output << <<~CLOSEEVENT
        {
          "type": "C",
          "frame": #{frames[call_tree.target.object_id]},
          "at": #{JSON.dump(original_start_time + call_tree.total_time)}
        }#{root ? "" : ","}
      CLOSEEVENT
    end
  end
end
