/*
 * generated by Xtext 2.16.0
 */
package dk.sdu.martinek.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import dk.sdu.martinek.myDSL.Model
import dk.sdu.martinek.myDSL.Import
import dk.sdu.martinek.myDSL.Headers
import dk.sdu.martinek.myDSL.Layouts
import dk.sdu.martinek.myDSL.Layout
import dk.sdu.martinek.myDSL.Entity
import dk.sdu.martinek.myDSL.Attribute
import dk.sdu.martinek.myDSL.MyStringValue
import dk.sdu.martinek.myDSL.MyIntConstant
import dk.sdu.martinek.myDSL.MyBoolConstant
import dk.sdu.martinek.myDSL.MyEntityIdentifier
import dk.sdu.martinek.myDSL.Property
import dk.sdu.martinek.validation.MyDSLValidator
import org.eclipse.xtext.naming.IQualifiedNameProvider
import com.google.inject.Inject
import org.eclipse.xtext.EcoreUtil2

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class MyDSLGenerator extends AbstractGenerator {

	@Inject extension IQualifiedNameProvider
		
	var String title
	var Model model

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		title = getFileName(resource)
		model = resource.allContents.filter(Model).next
		if (model.layouts !== null && !model.layouts.layouts.empty)
		{
			fsa.generateFile(title + '.html', generateHTML())
		}
		else
		{
			print("File " + resource +".gui dont contain layout nothign to generate.")
		}
	}
	
	def String generateHTML() {
		'''
		<!DOCTYPE html>
		<html>
			<head>
				<title>�title.toFirstUpper� GUI</title>
				�model.headers.generate�
			</head>
			<body>
				�model.layouts.generate�
			</body>
		</html>
		'''
	}
	
	def String generate(Headers headers)
	{
		if (headers === null)
		{
			return ""
		}
		var String res
		for (String header : headers.headers)
		{
			res += header + "\n"
		}
		return res
	}
	
	def String generate(Layouts layouts)
	{
		var String res = ""
		for (Layout layout: layouts.layouts)
		{
			res += generate(layout, 0)
		}
		return res
	}
	
	def String generate(Layout layout, int depth)
	{
		var String body = ""
		for (Layout child: layout.childs)
		{
			body += generate(child, depth + 1)
		}
		if (!body.empty)
		{
			body = "\n" + body.split("\\r?\\n").map[line|
				var indentation = ""
				for(var int i = 0; i <= depth; i++)
				{
					indentation += "\t"
				}
				return indentation + line
			].join("\n") + "\n"
		}
		return generate(layout.ref, body) + "\n"
	}
	
	def String generate(Entity entity, String body)
	{
		val widget = entity.ref
		var template = widget.template.value
		var properties = newArrayList()
		properties.addAll(widget.properties)
		//Defined attribute
		for (Attribute attr :  entity.attributes)
		{
			if (properties.contains(attr.ref))
			{
				var value = ""
				switch attr.right
				{
					MyStringValue: value = (attr.right as MyStringValue).^val
					MyIntConstant: value = (attr.right as MyIntConstant).^val.toString
					MyBoolConstant: value = (attr.right as MyBoolConstant).^val
					MyEntityIdentifier: value = generate((attr.right as MyEntityIdentifier).ref, "")
				}
				template = template.replaceAll("%"+attr.ref.name+"%", value)
				properties.remove(attr.ref);
			}
		}
		// Parent attributes
		var parent = entity.parent
		while (parent !== null && !properties.empty)
		{
			val toRemove = newArrayList()
			for (Property prop:  properties)
			{
				val attr = parent.attributes.findFirst[attr| attr.ref == prop]
				if (attr !== null)
				{
					var value = ""
					switch(attr.right)
					{
						MyStringValue: value = (attr.right as MyStringValue).^val
						MyIntConstant: value = (attr.right as MyIntConstant).^val.toString
						MyBoolConstant: value = (attr.right as MyBoolConstant).^val
						MyEntityIdentifier: value = generate((attr.right as MyEntityIdentifier).ref, "")
					}
					template = template.replaceAll("%"+attr.ref.name+"%", value)
					
					toRemove.add(attr.ref);
				}
			}
			properties.removeAll(toRemove)
			parent = parent.parent			
		}
		
		// Widget defaults
		if (!properties.empty)
		{
			for (Property prop:  properties)
			{
				var value = ""
				if (prop.defaultValue !== null)
				{
					switch(prop.defaultValue)
					{
						MyStringValue: value = (prop.defaultValue as MyStringValue).^val
						MyIntConstant: value = (prop.defaultValue as MyIntConstant).^val.toString
						MyBoolConstant: value = (prop.defaultValue as MyBoolConstant).^val
						MyEntityIdentifier: value = generate((prop.defaultValue as MyEntityIdentifier).ref, "")
					}
				}
				template = template.replaceAll("%"+prop.name+"%", value)
			}
			
		}
		
		template = template.replaceAll(MyDSLValidator.BODY_PROPERTY, body)
		template = template.replaceAll(MyDSLValidator.ID_PROPERTY, makeId(entity))
		return 	template
	}
	
	def String makeId(Entity entity)
	{
		return entity.fullyQualifiedName.toString("-")
	}
	
	def getFileName(Resource resource) {
		var uri = resource.URI.toString
		return uri.substring(uri.lastIndexOf('/') + 1, uri.length - 4) 
	}
}
