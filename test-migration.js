#!/usr/bin/env node

/**
 * uni-app x 迁移测试脚本
 * 用于验证迁移是否成功
 */

const fs = require('fs');
const path = require('path');

console.log('=== uni-app x 迁移测试 ===\n');

// 测试项目结构
function testProjectStructure() {
  console.log('1. 测试项目结构...');
  
  const requiredFiles = [
    'package.json',
    'vite.config.ts',
    'tsconfig.json',
    'src/App.vue',
    'src/main.ts',
    'src/manifest.json',
    'src/pages.json',
    'src/pages/index/index.vue',
    'src/store/index.ts',
    'src/utils/index.ts',
    'src/types/index.ts'
  ];
  
  let allFilesExist = true;
  
  requiredFiles.forEach(file => {
    if (fs.existsSync(file)) {
      console.log(`   ✅ ${file} 存在`);
    } else {
      console.log(`   ❌ ${file} 不存在`);
      allFilesExist = false;
    }
  });
  
  return allFilesExist;
}

// 测试package.json配置
function testPackageJson() {
  console.log('\n2. 测试package.json配置...');
  
  try {
    const packageJson = JSON.parse(fs.readFileSync('package.json', 'utf8'));
    
    const requiredDependencies = [
      '@dcloudio/uni-app',
      'vue',
      'pinia'
    ];
    
    const requiredDevDependencies = [
      'typescript',
      'vite',
      '@dcloudio/vite-plugin-uni'
    ];
    
    let allDependenciesExist = true;
    
    requiredDependencies.forEach(dep => {
      if (packageJson.dependencies && packageJson.dependencies[dep]) {
        console.log(`   ✅ 依赖 ${dep} 已配置`);
      } else {
        console.log(`   ❌ 依赖 ${dep} 未配置`);
        allDependenciesExist = false;
      }
    });
    
    requiredDevDependencies.forEach(dep => {
      if (packageJson.devDependencies && packageJson.devDependencies[dep]) {
        console.log(`   ✅ 开发依赖 ${dep} 已配置`);
      } else {
        console.log(`   ❌ 开发依赖 ${dep} 未配置`);
        allDependenciesExist = false;
      }
    });
    
    return allDependenciesExist;
  } catch (error) {
    console.log(`   ❌ package.json 解析失败: ${error.message}`);
    return false;
  }
}

// 测试TypeScript配置
function testTypeScriptConfig() {
  console.log('\n3. 测试TypeScript配置...');
  
  try {
    const tsconfig = JSON.parse(fs.readFileSync('tsconfig.json', 'utf8'));
    
    if (tsconfig.compilerOptions) {
      console.log('   ✅ TypeScript 编译选项已配置');
      return true;
    } else {
      console.log('   ❌ TypeScript 编译选项未配置');
      return false;
    }
  } catch (error) {
    console.log(`   ❌ tsconfig.json 解析失败: ${error.message}`);
    return false;
  }
}

// 测试页面配置
function testPagesConfig() {
  console.log('\n4. 测试页面配置...');
  
  try {
    const pagesJson = JSON.parse(fs.readFileSync('src/pages.json', 'utf8'));
    
    if (pagesJson.pages && pagesJson.pages.length > 0) {
      console.log(`   ✅ 页面配置已定义，共 ${pagesJson.pages.length} 个页面`);
      return true;
    } else {
      console.log('   ❌ 页面配置未定义');
      return false;
    }
  } catch (error) {
    console.log(`   ❌ pages.json 解析失败: ${error.message}`);
    return false;
  }
}

// 测试应用配置
function testManifestConfig() {
  console.log('\n5. 测试应用配置...');
  
  try {
    const manifestJson = JSON.parse(fs.readFileSync('src/manifest.json', 'utf8'));
    
    if (manifestJson.name && manifestJson.appid) {
      console.log(`   ✅ 应用配置已定义: ${manifestJson.name} (${manifestJson.appid})`);
      return true;
    } else {
      console.log('   ❌ 应用配置不完整');
      return false;
    }
  } catch (error) {
    console.log(`   ❌ manifest.json 解析失败: ${error.message}`);
    return false;
  }
}

// 测试Vue组件
function testVueComponents() {
  console.log('\n6. 测试Vue组件...');
  
  const vueFiles = [
    'src/App.vue',
    'src/pages/index/index.vue'
  ];
  
  let allComponentsValid = true;
  
  vueFiles.forEach(file => {
    if (fs.existsSync(file)) {
      const content = fs.readFileSync(file, 'utf8');
      
      if (content.includes('<template>') && content.includes('<script')) {
        console.log(`   ✅ ${file} 结构正确`);
      } else {
        console.log(`   ❌ ${file} 结构不正确`);
        allComponentsValid = false;
      }
    } else {
      console.log(`   ❌ ${file} 不存在`);
      allComponentsValid = false;
    }
  });
  
  return allComponentsValid;
}

// 测试状态管理
function testStore() {
  console.log('\n7. 测试状态管理...');
  
  try {
    const storeContent = fs.readFileSync('src/store/index.ts', 'utf8');
    
    if (storeContent.includes('defineStore') && storeContent.includes('useAppStore')) {
      console.log('   ✅ Pinia store 已正确定义');
      return true;
    } else {
      console.log('   ❌ Pinia store 定义不正确');
      return false;
    }
  } catch (error) {
    console.log(`   ❌ store 文件读取失败: ${error.message}`);
    return false;
  }
}

// 测试工具函数
function testUtils() {
  console.log('\n8. 测试工具函数...');
  
  try {
    const utilsContent = fs.readFileSync('src/utils/index.ts', 'utf8');
    
    const requiredFunctions = [
      'convertFullHalf',
      'fixPunctuation',
      'fixWave',
      'addIndentation',
      'getTextStats'
    ];
    
    let allFunctionsExist = true;
    
    requiredFunctions.forEach(func => {
      if (utilsContent.includes(`export function ${func}`)) {
        console.log(`   ✅ 函数 ${func} 已定义`);
      } else {
        console.log(`   ❌ 函数 ${func} 未定义`);
        allFunctionsExist = false;
      }
    });
    
    return allFunctionsExist;
  } catch (error) {
    console.log(`   ❌ utils 文件读取失败: ${error.message}`);
    return false;
  }
}

// 测试类型定义
function testTypes() {
  console.log('\n9. 测试类型定义...');
  
  try {
    const typesContent = fs.readFileSync('src/types/index.ts', 'utf8');
    
    const requiredTypes = [
      'AppSettings',
      'Preset',
      'TypesetResult',
      'ThemeType',
      'TextStats'
    ];
    
    let allTypesExist = true;
    
    requiredTypes.forEach(type => {
      if (typesContent.includes(`export interface ${type}`) || typesContent.includes(`export type ${type}`)) {
        console.log(`   ✅ 类型 ${type} 已定义`);
      } else {
        console.log(`   ❌ 类型 ${type} 未定义`);
        allTypesExist = false;
      }
    });
    
    return allTypesExist;
  } catch (error) {
    console.log(`   ❌ types 文件读取失败: ${error.message}`);
    return false;
  }
}

// 运行所有测试
function runAllTests() {
  const results = [];
  
  results.push(testProjectStructure());
  results.push(testPackageJson());
  results.push(testTypeScriptConfig());
  results.push(testPagesConfig());
  results.push(testManifestConfig());
  results.push(testVueComponents());
  results.push(testStore());
  results.push(testUtils());
  results.push(testTypes());
  
  console.log('\n=== 测试结果汇总 ===');
  
  const passedTests = results.filter(result => result).length;
  const totalTests = results.length;
  
  console.log(`通过测试: ${passedTests}/${totalTests}`);
  
  if (passedTests === totalTests) {
    console.log('\n🎉 所有测试通过！迁移成功！');
    console.log('\n下一步:');
    console.log('1. 运行 npm install 安装依赖');
    console.log('2. 运行 npm run dev:h5 启动H5端开发');
    console.log('3. 运行 npm run dev:mp-weixin 启动微信小程序开发');
  } else {
    console.log('\n⚠️ 部分测试失败，请检查上述问题。');
  }
  
  return passedTests === totalTests;
}

// 执行测试
runAllTests();