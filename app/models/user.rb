class User < ActiveRecord::Base
   include PublicActivity::Common
   include PgSearch

   multisearchable :against => [:name]
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable

    has_many :products, dependent: :destroy
    has_many :categories, dependent: :destroy
    has_one :identity, dependent: :destroy
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  validates :instagram_url, length:{minimum: 1}, :allow_blank => true 
  validates :twitter_url, length:{minimum: 1}, :allow_blank => true 
  validates :website, length:{minimum: 1}, :allow_blank => true 
  validates :name, length: {minimum: 3}, presence: true

  extend FriendlyId
  friendly_id :name, use: :slugged

  def instagram_url=(name)
    if name.length == 0
    else
    if name.index("http://instagram.com/") == nil
    name.gsub!('@','')
    name.insert(0, 'http://instagram.com/') 
    self[:instagram_url] = name.to_s
    else
    self[:instagram_url] = name.to_s
   end
  end
  end

  def twitter_url=(name)
    if name.length == 0
    else
    if name.index("http://twitter.com/") == nil
    name.gsub!('@','')
    name.insert(0, 'http://twitter.com/') 
    self[:twitter_url] = name.to_s
   else
    self[:twitter_url] = name.to_s
   end
  end
  end

  def should_generate_new_friendly_id?
    name_changed?
  end

   def admin?
    role == 'admin'
   end

  def points_count
    points_manager = PointsManager.new(self, nil)
    points_manager.points_count
  end

  def cat_points_count(category)
    points_manager = PointsManager.new(self, nil)
    points_manager.cat_points_count
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          #username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation! if user.respond_to?(:skip_confirmation)
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
end