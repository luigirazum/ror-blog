class Ability
  include CanCan::Ability
  # Define abilities for the user here. For example:
  #
  #        return unless user.present?
  #        can :read, :all
  #        return unless user.admin?
  #        can :manage, :all
  #
  # 'can' arguments:
  #  - The first argument 'action' => giving the user permission to do.
  #    + :manage, apply to every action.
  #    + common actions are :read, :create, :update and :destroy.
  #
  #  - The second argument 'resource' => where the user can perform the action on.
  #    + :all, apply to every resource.
  #    + Otherwise the Ruby class of the resource.
  #
  #  - The third argument(optional hash) 'conditions' to filter the objects.
  #    + For example, here the user can only update published articles.
  #        can :update, Article, published: true
  #
  # For details: https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md

  def initialize(user)
    # must be logged in
    return unless user.present?

    # can see users, posts, comments and likes
    can :read, :all

    # deletes Posts and Comments owned by user
    return unless user.user?

    can :destroy, Post, author: user
    can(:destroy, Comment, user:)
    return unless user.admin?

    # admin can delete any Posts
    can :destroy, Post
    can :destroy, Comment
  end
end
