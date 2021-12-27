module TestDataFactory
  # This module holds helper methods to create test data,
  # e.g. to create an user without much effort for the testing
  # of another model which has an user associated (e.g. a newspost).
  # Usually, these methods should NOT be used to test the behaviour
  # of the data, e.g. don't use the create_user method in user model
  # tests. There, you want to create the users directly using the
  # operations. As such, we have the operations tested in their own tests,
  # and can safely use them in other tests to create data.

  def create_user(attrs = {})
    ::Operations::Admin::User::Create.run!(
      user: {
        username: 'Testuser',
        email:    'testuser@example.com',
        password: 'Password123'
      }.merge(attrs)
    ).model.reload
  end
end
