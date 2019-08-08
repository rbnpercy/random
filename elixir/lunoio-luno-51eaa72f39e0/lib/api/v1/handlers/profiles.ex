defmodule Luno.Handlers.V1.Profiles do
  @moduledoc """
    Request handler for all User/Profile related actions.  All to be re-written with Auth/DB.
  """
  
  @doc """
    Get the full list of users under a parent account.
  """
  @spec get_user_list(integer, term) :: term
  def get_user_list(acc_id, qp) do
    case qp.params["limit"] do
      nil ->
        limit = 100
      _ ->
        limit = qp.params["limit"]
    end
    case qp.params["order_by"] do 
      nil ->
        order_by = "id"
      _ ->
        order_by = qp.params["order_by"]
    end  
    case qp.params["sort"] do
      nil ->
        sort = "ASC"
      _ ->
        sort = qp.params["sort"] 
    end 
    {:ok, db} = Dbo.DB.connect(Application.get_env(:dev, :database), Application.get_env(:dev, :db_user), Application.get_env(:dev, :db_pass))
    Dbo.DB.query(db, "SELECT row_to_json(users) FROM users ORDER BY #{order_by} #{sort} LIMIT #{limit};", [])
  end

  @doc """
    Create a User.  Return success map with User id.
  """ 
  ## HOW WE GONNA DO THIS?  HOW DO WE GET JSON POST VALUES INTO VARIABLES??
  @spec create_user(String.t) :: term
  def create_user(acc_id) do
    {:ok, db} = Dbo.DB.connect(Application.get_env(:dev, :database), Application.get_env(:dev, :db_user), Application.get_env(:dev, :db_pass))
    Dbo.DB.query(db, "INSERT INTO users (email, name, city, bio) VALUES('tester@me.me', 'Testy McTester', 'London', 'WAT') RETURNING id;", [])

  end

  @doc """
    Get a User's full details inc. subs && events etc.
  """
  @spec get_user(String.t, integer) :: term
  def get_user(acc_id, user_id) do
    {:ok, db} = Dbo.DB.connect(Application.get_env(:dev, :database), Application.get_env(:dev, :db_user), Application.get_env(:dev, :db_pass))
    Dbo.DB.query(db, "select row_to_json(users) from users where id=#{user_id};", [])
  end

  @doc """
    Get a User's profile.
  """
  @spec get_profile(String.t, integer) :: map
  def get_profile(acc_id, user_id) do
    case user_id do
      "69" ->
        %{"id" => "#{user_id}", "name" => "rbin", "age" => 24, "sex" => "Yes please"}
      "11" ->
        %{"id" => "#{user_id}", "name" => "tits", "age" => 99, "sex" => "No thankyou..."}
       _ ->
        false  
    end
  end

  @doc """
    Update a User Profile.  Delta updates.  Return User Map* if successful *(for now).
  """
  @spec update_user(String.t, integer) :: map
  def update_user(acc_id, user_id) do
    case user_id do
      "69" ->
        %{"id" => "#{user_id}", "email" => "me@rbin.co", "username" => "rbin", "name" => "Robin J", "age" => 24, "sex" => "Yes please"}
      _ ->
        false
    end
  end

  @doc """
    Delete a User Profile.
  """
  @spec delete_user(String.t, integer) :: map
  def delete_user(acc_id, user_id) do
    case user_id do
      "69" ->
        :ok
      _ ->
        false
    end
  end

end