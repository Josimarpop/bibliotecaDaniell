require 'test_helper'

class LivrosControllerTest < ActionController::TestCase

  setup do
    @livro = livros(:livro1)
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:livros)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create livro" do
    assert_difference('Livro.count', 0) do
      post :create, livro: { autor: @livro.autor, titulo: @livro.titulo }
    end
    assert_response :success
  end

  test "should show livro" do
    get :show, id: @livro
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @livro
    assert_response :success
  end

  test "should update livro" do
    put :update, id: @livro, livro: { autor: @livro.autor, titulo: @livro.titulo }
    assert_redirected_to livro_path(assigns(:livro))
  end

  test "should destroy livro" do
    assert_difference('Livro.count', -1) do
      delete :destroy, id: @livro
    end

    assert_redirected_to livros_path
  end
end
