class Link < ApplicationRecord

	validates_presence_of :url  
	validates :url, format: URI::regexp(%w[http https])  
	validates_uniqueness_of :slug  
	validates_length_of :url, within: 3..255, on: :create, message: "too long"  
	validates_length_of :slug, within: 3..255, on: :create, message: "too long"


	before_validation :generate_slug

	def generate_slug
		self.slug = SecureRandom.uuid[0..5] if self.slug.nil? || self.slug.empty?
		true
	end

	def self.shorten(url, slug = '')
		link = Link.where(url: url, slug: slug).first
		return link.short if link  

		link = Link.new(url: url, slug: slug)
		return link.short if link.save

		Link.shorten(url, slug + SecureRandom.uuid[0..2])
	end

	def get_short(base_url)
		base_url +"/"+self.slug
	end

	def update_count(location)
		self.clicked = self.clicked + 1
		countries = self.countries&.split(",") ? self.countries&.split(",") : [] << location.country
		self.countries = countries.uniq.join(",") if location.country.present?
		ip_addresses = self.ip_addresses&.split(",") ? self.ip_addresses&.split(",") : [] << location.ip 
		self.ip_addresses = ip_addresses.uniq.join(",")  if location.ip.present?
		true if self.save		
	end

end
