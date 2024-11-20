# Not recommended

describe 'screening widget' do
  [true, false].map do |rails_enabled|
    context ":rails_enabled feature flag is #{rails_enabled}" do
      before do
        FeatureFlag.create!(name: 'rails_enabled', enabled: rails_enabled)
      end

      it 'does something' do
        # ...
      end
    end
  end
end

# Recommended

describe 'screening widget' do
  shared_examples 'does something' do
    # ...
  end

  context ':rails_enabled feature flag is true' do
    before do
      FeatureFlag.create!(name: 'rails_enabled', enabled: true)
    end

    include_examples 'does something'
  end

  context ':rails_enabled feature flag is false' do
    before do
      FeatureFlag.create!(name: 'rails_enabled', enabled: false)
    end

    include_examples 'does something'
  end
end
