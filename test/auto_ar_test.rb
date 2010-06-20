require File.dirname(__FILE__) + '/test_helper.rb'

class AutoArTest < Test::Unit::TestCase
  DBFILE = "test/auto_ar_test.sqlite3"
  def setup
    ActiveRecord::Base.establish_connection(:adapter => "sqlite3",
                                            :database => DBFILE)
    migrate = Class.new(ActiveRecord::Migration) do
      def self.up
        create_table(:blogs) do |t|
          t.string :title
          t.text :body
        end
        create_table(:comments) do |t|
          t.references :blog
          t.string :name
          t.string :body
        end
      end
    end
    migrate.up
    conn = ActiveRecord::Base.connection
    conn.execute("insert into blogs (id, title, body) values (1, 'first post', 'hello. how are you?')")
    conn.execute("insert into comments (id, blog_id, name, body) values (1, 1, 'tmaeda', 'fine')")
    conn.execute("insert into comments (id, blog_id, name, body) values (2, 1, 'tmaeda2', 'fine')")

    conn.execute("insert into blogs (id, title, body) values (2, 'second post', 'good night')")
    conn.execute("insert into comments (id, blog_id, name, body) values (3, 2, 'tmaeda', 'sweet dreams')")
    conn.execute("insert into comments (id, blog_id, name, body) values (4, 2, 'tmaeda2', 'good night')")
    conn.execute("insert into comments (id, blog_id, name, body) values (5, 2, 'tmaeda2', 'see you!')")

  end
  def teardown
    File.unlink(DBFILE)
  end

  def test_find_parent
    blogs = Blog.find(:all)
    assert_equal 2, blogs.size
  end

  def test_find_children
    comments = Comments.find(:all)
    assert_equal 5, comments.size
  end

  def test_relation_parent_to_children
    blog = Blog.find(1)
    comments = blog.comments
    assert_equal 2, comments.size
  end

  def test_relation_children_to_parent
    comment = Comment.find(3)
    blog = comment.blog
    assert_equal 2, blog.id
  end

  def test_relation_parent_to_children_to_parent
    blog = Blog.find(1)
    blog = blog.comments[0].blog
    assert_equal 1, blog.id
  end

  def test_relation_children_to_parent_to_children
    comment = Comment.find(4)
    comments = comment.blog.comments
    assert_equal 3, comments.size
  end

end
