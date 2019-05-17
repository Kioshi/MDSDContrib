/*
 * generated by Xtext 2.16.0
 */
package dk.sdu.martinek.validation

import dk.sdu.martinek.myDSL.Widget
import java.util.ArrayList
import java.util.regex.Pattern
import java.util.stream.Collectors
import org.eclipse.xtext.validation.Check
import dk.sdu.martinek.myDSL.Entity
import dk.sdu.martinek.myDSL.Attribute
import dk.sdu.martinek.myDSL.impl.MyEntityIdentifierImpl
import dk.sdu.martinek.myDSL.impl.SpecificationImpl
import dk.sdu.martinek.myDSL.impl.EntityImpl
import org.eclipse.xtext.EcoreUtil2
import dk.sdu.martinek.myDSL.Specification

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class MyDSLValidator extends AbstractMyDSLValidator {
	
	public static val INVALID_NAME = 'invalidName'

	@Check
	def checkWidgetDuplicates(Widget element) {
		val propetiesGrouped = element.properties.groupBy[e|e?.eGet(e?.eClass?.getEStructuralFeature("name"))]
		val propertiesDuplicated = propetiesGrouped.filter[p1, p2|p2.length>1]
		val onlytheEObjects = propertiesDuplicated.values().stream().flatMap(e|e.stream).collect(
			Collectors.toList())
		onlytheEObjects.forEach [ e |
			val nameRef = e?.eClass?.getEStructuralFeature("name")
			val nameAttr = e?.eGet(nameRef)

			error('Duplicate name ' + nameAttr + " for " + e.eClass.name,e, nameRef, INVALID_NAME)
		]
	}
	
	public static val MISSING_PROPERTIES = 'missingProperties'
	public static val UNUSED_PROPERTIES = 'unusedProperties'
	
	@Check
	def checkWidgetTemplate(Widget element) {
		val pattern = Pattern.compile("(%)([a-zA-Z]+?)(%)");
        val matcher = pattern.matcher(element.template.value);

        val  listMatches = new ArrayList<String>();

        while(matcher.find())
        {
            listMatches.add(matcher.group(2));
        }
        
        val missingProperties = new ArrayList<String>()
        element.properties.forEach[ property |
        	if (!listMatches.contains(property.name))
        	error('Property ' + property.name + " is unused in template", property, property.eClass.getEStructuralFeature("name"), UNUSED_PROPERTIES)
        ]
       
        listMatches.forEach[ match |
        	if (!element.properties.stream().map(e| e.name).collect(
				Collectors.toList()).contains(match))
        		missingProperties.add(match)        		
        ]
        
        if (!missingProperties.empty)
        {
        	if (missingProperties.size > 1)
        		error('Properties ' + missingProperties.stream().collect( Collectors.joining( "," ) ) + " are not defined in Widget", element.template, null, MISSING_PROPERTIES)
    		else
        		error('Property ' + missingProperties.get(0) + " is not defined in Widget", element.template, null, "missingBody")
        	
        }
		
	}
	
	@Check
	def checkIfWidgetHaveMultipleBodyReferencesInTemplate(Widget widget) 
	{
		val pattern = Pattern.compile("_BODY_");
        val matcher = pattern.matcher(widget.template.value);
		var count = 0;
		while (matcher.find())
		    count++;
		if (count > 1)
			error("Widget's "+ widget.name +" template have defined '_BODY_' multiple times", widget, null, "multipleBodies")

	}	
	
	@Check
	def checkIfEntityCanHaveChild(Entity entity) 
	{
		if (!entity.childs.empty)
		{
			val pattern = Pattern.compile("_BODY_");
	        val matcher = pattern.matcher(entity.ref.template.value);
	
			if (!matcher.find())
				error('Entity ' + entity.name + " can not have childs since its Widget ("+ entity.ref.name +") template dont have defined '_BODY_' in its template", entity, null, MISSING_PROPERTIES)
			
		}		
	}	
	
	def boolean isComplete(EntityImpl current, EntityImpl attributeEntity)
	{
		if (current == attributeEntity)
		{
			return false
		}
		
        val rootElement = EcoreUtil2.getRootContainer(current)
        val specifications = EcoreUtil2.getAllContentsOfType(rootElement, Specification)
        val specification = specifications.findFirst[spec|
        	if (spec.ref == current as Entity)
        	{
        		return true
    		}
        	return false
        ]
        if (specification === null)
        {
        	return false
        }
        
        for (Attribute attr : specification.attributes)
        {
        	val value = attr.right
        	if (value instanceof MyEntityIdentifierImpl)
        	{
        		if (!isComplete(value.ref as EntityImpl, attributeEntity))
        		{
        			return false
        		}
        	}
        }
		return true
	}
	
	@Check
	def checkIfAttributeValueEntityIsComplete(Attribute attribute) 
	{
		val value = attribute.right
		if (value instanceof MyEntityIdentifierImpl)
		{
			if (!isComplete(value.ref as EntityImpl, (attribute.eContainer as SpecificationImpl).ref as EntityImpl))
			{
				error('Entity '+((attribute.eContainer as SpecificationImpl).ref as EntityImpl).name+' specification attribute "' + attribute.ref.name + ' = '+ (value.ref as EntityImpl).name +'" references entity whose specification is not complete (or include cyclic reference)', attribute, null, "inclompleteEntity")
			}
		}
	}
}
