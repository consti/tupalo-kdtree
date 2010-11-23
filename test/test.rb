require "#{File.expand_path(File.dirname(__FILE__))}/../ext/kdtree.o"
require "test/unit"
require "tempfile"

#
# create a tree
#

class KDTreeTest < Test::Unit::TestCase
  TMP = "#{Dir.tmpdir}/kdtree_test"
  
  def test_nearest
    setup_tree(1000)
    100.times do
      pt = [rand_coord, rand_coord]

      # kdtree search
      id = @kdtree.nearest(pt[0], pt[1])
      kdpt = @points[id]

      # slow search
      sortpt = @points.sort_by { |i| distance(i, pt) }.first

      # assert
      kdd = distance(kdpt, pt)
      sortd = distance(sortpt, pt)
      assert((kdd - sortd).abs < 0.0000001, "kdtree didn't return the closest result")
    end
  end

  def test_nearestk
    setup_tree(1000)    
    100.times do
      pt = [rand_coord, rand_coord]

      # kdtree search
      list = @kdtree.nearestk(pt[0], pt[1], 5)
      kdpt = @points[list.last]

      # slow search
      sortpt = @points.sort_by { |i| distance(i, pt) }[list.length - 1]

      # assert
      kdd = distance(kdpt, pt)
      sortd = distance(sortpt, pt)
      assert((kdd - sortd).abs < 0.0000001, "kdtree didn't return the closest result")
    end
  end

  def test_persist
    setup_tree(1000)

    begin
      # write
      File.open(TMP, "w") { |f| @kdtree.persist(f) }
      # read
      kdtree2 = File.open(TMP, "r") { |f| KDTree.new(f) }

      # now test some random points
      100.times do
        pt = [rand_coord, rand_coord]
        id1 = @kdtree.nearest(*pt)
        id2 = kdtree2.nearest(*pt)
        assert(id1 == id2, "kdtree2 differed from kdtree")
      end
    ensure
      File.unlink(TMP)
    end

    # now test magic problems
    begin
      File.open(TMP, "w") { |f| f.puts "That ain't right" }
      assert_raise RuntimeError do
        File.open(TMP, "r") { |f| KDTree.new(f) }
      end
    ensure
      File.unlink(TMP)
    end
  end

  def dont_test_speed
    printf("\n")
    sizes = [1, 100, 1000, 10000, 100000, 1000000]
    ks = [1, 5, 50, 255]
    sizes.each do |s|
      points = (0...s).map { |i| [rand_coord, rand_coord, i] }

      # build
      tm = Time.now
      kdtree = KDTree.new(points)
      printf "build %d took %.6fs\n", s, Time.now - tm
      
      begin
        # write
        tm = Time.now
        File.open(TMP, "w") { |f| kdtree.persist(f) }
        printf "write %d took %.6fs\n", s, Time.now - tm
        # read
        tm = Time.now
        File.open(TMP, "r") { |f| KDTree.new(f) }
        printf "read  %d took %.6fs\n", s, Time.now - tm        
      ensure
        File.unlink(TMP)
      end
      
      ks.each do |k|
        total = count = 0
        100.times do
          tm = Time.now
          if k == 1
            kdtree.nearest(rand_coord, rand_coord)
          else
            kdtree.nearestk(rand_coord, rand_coord, k)
          end
          total += Time.now - tm
          count += 1
        end
        printf "avg query time = %.6fs [%d/%d]\n", total / count, s, k
      end
    end
  end

  protected
  
  def setup_tree(len)
    @points = (0...len).map { |i| [rand_coord, rand_coord, i] }
    @kdtree = KDTree.new(@points)
  end
  
  def distance(a, b)
    x, y = a[0] - b[0], a[1] - b[1]
    x * x + y * y
  end

  def rand_coord
    rand(0) * 10 - 5
  end
end
