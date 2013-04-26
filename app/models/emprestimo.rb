# encoding: utf-8
class Emprestimo < ActiveRecord::Base
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
  belongs_to :aluno
  belongs_to :livro
  attr_accessible :livro_id, :aluno_id, :data_de_devolucao, :data_de_emprestimo, :devolvido_em
  validates_presence_of :data_de_emprestimo, :data_de_devolucao, :aluno, :livro

  validate :data_de_emprestimo_no_passado, :on => :create
  validate :data_de_devolucao_anterior_a_data_do_emprestimo
  validate :data_de_devolucao_deve_ser_de_no_maximo_7_dias
  validate :livro_nao_disponivel, :on => :create
  validate :devolvido_em_anterior_a_data_de_emprestimo, :on => :update
  validate :status, :on => :create

  def status
    if devolvido_em and data_de_devolucao
      errors.add(:devolvido_em, "Entregue") if devolvido_em < data_de_devolucao
      errors.add(:devolvido_em, ":  ----Entregue com atraso----") if devolvido_em > data_de_devolucao
    end
  end

  def data_de_devolucao_deve_ser_de_no_maximo_7_dias
    if data_de_devolucao and data_de_emprestimo
      errors.add(:data_de_devolucao, "A data de devolução deve ser de no máximo 7 dias após a data de empréstimo.") if (data_de_devolucao - data_de_emprestimo).days > 7.days
    end
  end

  def data_de_emprestimo_no_passado
    if data_de_emprestimo
      errors.add(:data_de_emprestimo, "Empréstimo não pode ser solicitado para o passado.") if data_de_emprestimo < Date.today
    end
  end

  def data_de_devolucao_anterior_a_data_do_emprestimo
    if data_de_devolucao and data_de_emprestimo
      errors.add(:data_de_devolucao, "A data de devolução não pode ser anterior a data de empréstimo.") if data_de_devolucao < data_de_emprestimo
    end
  end

  def devolvido_em_anterior_a_data_de_emprestimo
    if devolvido_em and data_de_emprestimo
      errors.add(:devolvido_em, "A data de 'devolvido em' não pode ser anterior a data de empréstimo.")  if devolvido_em < data_de_emprestimo
    end
  end

  def livro_nao_disponivel
    if livro
      errors.add(:livro, "O livro esta emprestado, voce nao pode levar esse livro") if !livro.disponivel?
    end
  end
end
