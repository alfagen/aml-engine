class AddGlobalize < ActiveRecord::Migration[5.2]
	def change
		reversible do |dir|
			dir.up do
				AML::DocumentKind.create_translation_table!( { title: :string, details: :text, file_title: :string }, { remove_source_columns: true, migrate_data: true } )
        AML::DocumentKindFieldDefinition.create_translation_table!( { title: :string }, { remove_source_columns: true, migrate_data: true } )
        AML::DocumentGroup.create_translation_table!( { title: :string, details: :text }, { remove_source_columns: true, migrate_data: true } )
        AML::RejectReason.create_translation_table!( { title: :string }, { remove_source_columns: true, migrate_data: true } )
        AML::Status.create_translation_table!( { title: :string, details: :text }, { remove_source_columns: true, migrate_data: true } )
			end

			dir.down do
        [AML::DocumentKind, AML::DocumentKindFieldDefinition, AML::DocumentGroup, AML::RejectReason, AML::Status].each do |model|
          model.drop_translation_table! migrate_data: true
        end
			end
		end
	end
end
