# -*- coding: utf-8 -*-

class <%= controller_class_name %>Controller < ApplicationController
  respond_to :html

  # POST <%= route_url %>
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "params[:#{singular_table_name}]") %>
    if @<%= singular_table_name %>.save
      flash[:notice] = "<%= class_name %> successfully created"
      respond_with(@<%= singular_table_name %>)
    else
      render :new
    end
  end

  # DELETE <%= route_url %>/1
  def destroy
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    flash[:notice] = "<%= class_name %> successfully destroyed." if @<%= orm_instance.destroy %>
    respond_with(@<%= singular_table_name %>, location: <%= plural_table_name %>_path)
  end

  # GET <%= route_url %>/1/edit
  def edit
    respond_with(@<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>) do |format|
      format.html { render action: :edit }
    end
  end

  # GET <%= route_url %>
  def index
    respond_with(@<%= plural_table_name %> = <%= orm_class.all(class_name) %>)
  end

  # GET <%= route_url %>/new
  def new
    respond_with(@<%= singular_table_name %> = <%= orm_class.build(class_name) %>)
  end

  # GET <%= route_url %>/1
  def show
    respond_with(@<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>)
  end

  # PUT <%= route_url %>/1
  def update
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    if @<%= orm_instance.update_attributes("params[:#{singular_table_name}]") %>
      flash[:notice] = "<%= class_name %> successfully updated."
      respond_with(@<%= singular_table_name %>)
    else
      render :edit
    end
  end
end
