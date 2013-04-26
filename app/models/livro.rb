class Livro < ActiveRecord::Base
  has_many :emprestimos, :dependent => :nullify
  include BeautifulScaffoldModule      

  before_save :fulltext_field_processing

  def fulltext_field_processing
    # You can preparse with own things here
    generate_fulltext_field([])
  end
  scope :sorting, lambda{ |options|
    attribute = options[:attribute]
    direction = options[:sorting]

    attribute ||= "id"
    direction ||= "DESC"

    order("#{attribute} #{direction}")
  }
    # You can OVERRIDE this method used in model form and search form (in belongs_to relation)
  def caption
    (self["name"] || self["label"] || self["description"] || "##{id}")
  end
  attr_accessible :emprestimo_ids, :autor, :titulo
  has_many :emprestimos, :dependent => :destroy

  validates_presence_of :titulo, :autor
  validates_uniqueness_of :titulo

  def disponivel?
    if emprestimos.where(:devolvido_em => nil).count > 0
      false
    else
      true
    end
  end
end
