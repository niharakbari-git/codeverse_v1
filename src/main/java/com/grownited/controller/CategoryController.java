package com.grownited.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.grownited.entity.CategoryEntity;
import com.grownited.repository.CategoryRepository;


//JPA -> specification  

@Controller
public class CategoryController {

	@Autowired // inject 
	CategoryRepository categoryRepository; 
	
	@GetMapping("newCategory")
	public String newCategory(Model model) {
		model.addAttribute("category", new CategoryEntity());
		return "NewCategory";
	}

	@PostMapping("saveCategory")
	public String saveCategory(CategoryEntity categoryEntity) {

		if (categoryEntity.getActive() == null) {
			if (categoryEntity.getCategoryId() != null) {
				Optional<CategoryEntity> existingCategory = categoryRepository.findById(categoryEntity.getCategoryId());
				categoryEntity.setActive(existingCategory.map(CategoryEntity::getActive).orElse(true));
			} else {
				categoryEntity.setActive(true);
			}
		}
		//insert 
		categoryRepository.save(categoryEntity);
		return "redirect:/listCategory";
	}

	@GetMapping("editCategory")
	public String editCategory(Integer id, Model model) {
		Optional<CategoryEntity> opCategory = categoryRepository.findById(id);
		if (opCategory.isEmpty()) {
			return "redirect:/listCategory";
		}

		model.addAttribute("category", opCategory.get());
		return "NewCategory";
	}

	@GetMapping("deleteCategory")
	public String deleteCategory(Integer id) {
		if (id != null && categoryRepository.existsById(id)) {
			categoryRepository.deleteById(id);
		}
		return "redirect:/listCategory";
	}
	
	@GetMapping("listCategory")
	public String listCategory(Model model) {
		//select * from categories ; 
		//1
		//2
		//3
		//4
		//List<Entity> 
		List<CategoryEntity> categoryList = categoryRepository.findAll();
		model.addAttribute("categoryList",categoryList);//
		
		return "ListCategory";
	}
		

}
