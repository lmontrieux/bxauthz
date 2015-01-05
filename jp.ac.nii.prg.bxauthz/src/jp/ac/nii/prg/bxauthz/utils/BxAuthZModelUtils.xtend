package jp.ac.nii.prg.bxauthz.utils

import jp.ac.nii.prg.bxauthz.bxAuthZ.Policy
import jp.ac.nii.prg.bxauthz.bxAuthZ.Rule
import jp.ac.nii.prg.bxauthz.bxAuthZ.Condition
import jp.ac.nii.prg.bxauthz.bxAuthZ.Attribute

class BxAuthZModelUtils {
	def static getReadRules(Policy policy) {
		policy.getRulesOfType('read')
	}
	
	def static getWriteRules(Policy policy) {
		getCreateRules(policy) + getUpdateRules(policy) + getDeleteRules(policy)
	}
	
	def static getCreateRules(Policy policy) {
		policy.getRulesOfType('create')
	}
	
	def static getUpdateRules(Policy policy) {
		policy.getRulesOfType('update')
	}
	
	def static getDeleteRules(Policy policy) {
		policy.getRulesOfType('delete')
	}
	
	def static getReadAttributes(Policy policy) {
		var attrs = newHashSet
		for (rule:policy.getReadRules) {
			attrs.addAll(rule.getAttributes)
		}
		attrs
	}
	
	def static getWriteAttributes(Policy policy) {
		var attrs = newHashSet
		for (rule:policy.getWriteRules) {
			attrs.addAll(rule.getAttributes)
		}
		attrs
	}
	
	def static getAttributes(Rule rule) {
		var attrs = newHashSet
		for (condition:rule.conditions) {
			attrs.addAll(condition.getAttributes)
		}
		attrs
	}
	
	def static getAttributes(Condition condition) {
		condition.expression.eAllContents.filter(typeof(Attribute))
	}
	
	private def static getRulesOfType(Policy policy, String type) {
		policy.rules.filter[rule | rule.actions.contains(type)]
	}
}