module Crystalg::Trees
  class LinkCutTree(T)
    INF = Int32::MAX

    def initialize(size)
      @left = Array(Int32?).new(size, nil)
      @right = Array(Int32?).new(size, nil)
      @parent = Array(Int32?).new(size, nil)
      @val = Array(T).new(size, 0)
      @mini = Array(T).new(size, INF)
      @minId = Array(Int32).new(size, -1)
      @lazy = Array(T).new(size, 0)
      @rev = Array(Bool).new(size, false)
    end

    def push(id : Int32)
      l = @left[id]
      r = @right[id]

      @val[id] += @lazy[id]
      @mini[id] += @lazy[id]

      @lazy[l] += @lazy[id] if !l.nil?
      @lazy[r] += @lazy[id] if !r.nil?
      @lazy[id] = 0

      if @rev[id]
        @rev[id] = false
        @rev[l] ^= true if !l.nil?
        @rev[r] ^= true if !r.nil?
        @left[id], @right[id] = @right[id], @left[id]
      end
    end

    def update_min(id : Int32, ch : Int32)
      if @mini[ch] < @mini[id]
        @mini[id] = @mini[ch]
        @minId[id] = @minId[ch]
      end
    end

    def update(id : Int32)
      l = @left[id]
      r = @right[id]
      @mini[id] = @val[id]
      @minId[id] = id
      push(id)

      unless l.nil?
        push(l)
        update_min(id, l)
      end

      unless r.nil?
        push(r)
        update_min(id, r)
      end
    end

    def root?(id : Int32)
      parent_index = @parent[id]
      return true if parent_index.nil?
      is_left = (@left[parent_index] != id)
      is_right = (@right[parent_index] != id)
      is_left && is_right
    end

    def connect(ch : Int32?, par : Int32, is_left : Bool)
      if is_left
        @left[par] = ch
      else
        @right[par] = ch
      end
      @parent[ch] = par if !ch.nil?
    end

    def rotate(id : Int32)
      par = @parent[id].as(Int32)
      q = @parent[par]
      push(par)
      push(id)
      is_left = (id == @left[par])
      is_root = root?(par)
      if is_left
        connect(@right[id], par, is_left)
      else
        connect(@left[id], par, is_left)
      end
      connect(par, id, !is_left)
      if !is_root
        q = q.as(Int32)
        connect(id, q, par == @left[q])
      else
        @parent[id] = q
      end
      update(par)
    end

    def splay(id : Int32)
      until root?(id)
        par = @parent[id].as(Int32)
        unless root?(par)
          is_left = (id == @left[par])
          parent_is_left = (par == @left[@parent[par].as(Int32)])
          if is_left ^ parent_is_left
            rotate(par)
          else
            rotate(id)
          end
        end
        rotate(id)
      end
      update(id)
    end

    def expose(id : Int32) : Int32?
      last = nil
      y = id
      until y.nil?
        splay(y)
        @right[y] = last
        last = y
        y = @parent[y]
      end
      splay(id)
      last
    end

    def find_root(id : Int32) : Int32
      expose(id)
      until @right[id].nil?
        id = @right[id]
      end
      id
    end

    def connected?(x : Int32, y : Int32)
      expose(x)
      expose(y)
      !@parent[x].nil?
    end

    def evert(par : Int32) : Nil
      expose(par)
      @rev[par] ^= true
    end

    def link(ch : Int32, par : Int32) : Nil
      evert(ch)
      @parent[ch] = par
    end

    def cut(id : Int32) : Nil
      expose(id)
      @parent[@right[id].as(Int32)] = nil
      @right[id] = nil
    end

    def lca(ch : Int32, par : Int32) : Int32?
      expose(ch)
      expose(par)
    end

    def min_id(id : Int32) : Int32
      expose(id)
      @minId[id]
    end

    def min(from : Int32, to : Int32) : Int32
      evert(from)
      expose(to)
      @mini[to]
    end

    def add(id : Int32, val : Int32)
      expose(id)
      @lazy[id] = val
    end

    def add(from : Int32, to : Int32, v : Int32)
      evert(from)
      expose(to)
      @lazy[to] += v
    end
  end
end
